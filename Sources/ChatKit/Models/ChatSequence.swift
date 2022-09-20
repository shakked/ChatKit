//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit
import GitMart

let projectID = "63236af27c2d722951b52995"

public class ChatSequence {
    
    let allChats: [Chat]
    var chats: [Chat]
    public var readingSpeed: Double = 1.0
    
    var levels: [[Chat]] = []
    weak var controller: UIViewController?
    
    var addMessage: ((String) -> ())? = nil
    var addUserMessage: ((String) -> ())? = nil
    var showButtons: ((Chat) -> ())? = nil
    var hideButtons: (() -> ())? = nil
    var showCancelButton: (() -> ())? = nil
    var dismiss: (() -> ())? = nil
    var startTyping: (() -> ())? = nil
    var stopTyping: (() -> ())? = nil
    var openURL: ((URL, Bool) -> ())? = nil
    
    var isWaitingForButtonPressed: Bool = false
    var previousAnswer: String?
    
    public init(chats: [Chat]) {
        self.chats = chats
        self.allChats = chats
        
        // GitMart.shared.confirmAccessToProject(projectID: projectID)
    }
    
    public func start() {
        continueChat()
    }
    
    private func next() -> Chat? {
        if chats.count > 0 {
            let first = chats.removeFirst()
            return first
        }
        return nil
    }
    
    private func continueChat() {
        let next = self.next()
        var nextMessage = next?.message ?? ""
        let estimatedReadingTime = readingTime(nextMessage)
        if let previousAnswer = previousAnswer {
            nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
        }
        
        if let _ = next as? ChatMessage {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.continueChat()
            }
        } else if let _ = next as? ChatRandomMessage {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.continueChat()
            }
        } else if let _ = next as? ChatUserMessage {
            self.addUserMessage?(nextMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.continueChat()
            }
        } else if let next = next as? ChatMessageConditional {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.showButtons?(next)
            }
        } else if let next = next as? ChatButtons {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (estimatedReadingTime / 2.0)) {
                self.stopTyping?()
                self.showButtons?(next)
            }
        } else if let next = next as? ChatButton {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (estimatedReadingTime / 2.0)) {
                self.stopTyping?()
                self.showButtons?(next)
            }
        } else if let _ = next as? ChatShowCancelButton {
            self.showCancelButton?()
            self.continueChat()
        } else if let next = next as? ChatFallingEmojis {
            FallingEmojiView.shared.show(emoji: next.emoji)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
                self.continueChat()
            }
        } else if let next = next as? ChatDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + next.after) { [unowned self] in
                self.dismiss?()
            }
        } else if let next = next as? ChatDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + next.delay) { [unowned self] in
                self.continueChat()
            }
        } else if let _ = next as? ChatLoopStart {
            self.continueChat()
        } else if let next = next as? ChatLoopEnd {
            if let indexOfStart = self.allChats.firstIndex(where: { ($0 as? ChatLoopStart)?.id == next.id }) {
                self.chats = Array(self.allChats[indexOfStart..<self.allChats.count])
                self.continueChat()
            }
        } else if let next = next as? ChatRunLogic, let controller = controller {
            next.block(controller)
            self.continueChat()
        } else if let next = next as? ChatOpenURL {
            self.openURL?(next.url, next.withSafariVC)
            self.continueChat()
        } else {
            if self.levels.count > 0 {
                self.chats = self.levels.removeLast()
                self.continueChat()
            } else {
                print("Nothing Left")
            }
        }
    }
    
    func userTappedButton(index: Int, buttonText: String, chat: Chat, controller: ChatViewController) {
        self.hideButtons?()
        self.previousAnswer = buttonText
        
        if let chat = chat as? ChatMessageConditional {
            let userMessage = chat.options[index]
            self.addUserMessage?(userMessage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + userMessage.estimatedReadingTime()) {
                if chat.childChats.count > 0 {
                    self.levels.append(self.chats)
                    let nextChats = chat.childChats.count == 1 ? chat.childChats.first! : chat.childChats[index]
                    self.chats = nextChats
                    self.continueChat()
                } else {
                    self.continueChat()
                }
            }
        } else if let chat = chat as? ChatButtons {
            let button = chat.buttons[index]
            button.tapped?(controller) // This is something the user will put in, an action of some sort
            self.continueChat()
        } else if let chat = chat as? ChatButton {
            chat.tapped?(controller)
            self.continueChat()
        }
    }
    
    private func readingTime(_ string: String) -> Double {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = string.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        
        return (1 + Double(words.count) * 0.2) / readingSpeed
    }
}
