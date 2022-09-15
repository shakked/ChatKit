//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public class ChatSequence {
    
    var chats: [Chat]
    
    var levels: [[Chat]] = []
    
    var addMessage: ((String) -> ())? = nil
    var addUserMessage: ((String) -> ())? = nil
    var showButtons: ((Chat) -> ())? = nil
    var hideButtons: (() -> ())? = nil
    var showCancelButton: (() -> ())? = nil
    var dismiss: (() -> ())? = nil
    var startTyping: (() -> ())? = nil
    var stopTyping: (() -> ())? = nil
    
    var isWaitingForButtonPressed: Bool = false
    var previousAnswer: String?
    
    public init(chats: [Chat]) {
        self.chats = chats
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
        if let previousAnswer = previousAnswer {
            nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
        }
        
        if let next = next as? ChatMessage {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + next.estimatedReadTime) {
                self.stopTyping?()
                self.continueChat()
            }
        } else if let next = next as? UserChatMessage {
            self.addUserMessage?(nextMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + next.estimatedReadTime) {
                self.continueChat()
            }
        } else if let next = next as? ChatMessageConditional {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + nextMessage.estimatedReadingTime()) {
                self.stopTyping?()
                self.showButtons?(next)
            }
        } else if let next = next as? ChatButton {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (nextMessage.estimatedReadingTime() / 2.0)) {
                self.stopTyping?()
                self.showButtons?(next)
            }
        } else if let _ = next as? ChatShowCancelButton {
            self.showCancelButton?()
            self.continueChat()
        } else if let next = next as? ChatFallingEmojis {
            FallingEmojiView.shared.show(emoji: next.emoji)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [unowned self] in
                self.continueChat()
            }
        } else if let next = next as? ChatContinueButton {
            self.showButtons?(next)
        } else if let next = next as? ChatDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + next.after) { [unowned self] in
                self.dismiss?()
            }
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
        } else if let chat = chat as? ChatButton {
            let button = chat.buttons[index]
            button.tapped(controller) // This is something the user will put in, an action of some sort
            self.continueChat()
        } else if let chat = chat as? ChatContinueButton {
            self.continueChat()
        }
    }
}
