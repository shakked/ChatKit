//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit
import GitMart

let libraryID = "632b6c551015bcf8ac4843d9"

public class ChatSequence {
    
    public let id: String
    public var readingSpeed: Double = 1.0
    public var analyticEventBlock: ((ChatAnalyticEvent) -> ())? = nil
    
    let allChats: [Chat]
    private(set) var chats: [Chat]
    
    var levels: [[Chat]] = []
    weak var controller: UIViewController?
    
    var addMessage: ((String) -> ())? = nil
    var addUserMessage: ((String) -> ())? = nil
    var showButtons: ((Chat) -> ())? = nil
    var showTextInput: ((ChatTextInput) -> ())? = nil
    var hideButtons: (() -> ())? = nil
    var showCancelButton: (() -> ())? = nil
    var dismiss: (() -> ())? = nil
    var startTyping: (() -> ())? = nil
    var stopTyping: (() -> ())? = nil
    var openURL: ((URL, Bool) -> ())? = nil
    
    var isWaitingForButtonPressed: Bool = false
    var previousAnswer: String?
    var startTime: Date = Date()
    
    public init(id: String, chats: [Chat]) {
        self.id = id
        self.chats = chats
        self.allChats = chats
        
        GitMart.shared.confirmAccessToProject(library: ChatKit.self)
        ChatKit.shared.registerChatSequence(sequence: self)
    }
    
    func copy() -> ChatSequence {
        let sequence = ChatSequence(id: id, chats: chats)
        sequence.readingSpeed = readingSpeed
        sequence.analyticEventBlock = analyticEventBlock
        return sequence
    }
    
    /*
     
     Scheduling
     - ChatKit.scheduleSequence(sequence)
     - I schedule it for 3 days from now
     - in 3 days, the user gets a notification (or just opens the app)
     - on app open, I check if its time to show the chat
     - if it is, I pull the chat from some sort of dictionary?
     in that case the user would need to store the chatsequence in some sort of
     object that I have access to, where I can get the chatSequence based on an ID
     
     Its not ideal
     
     I want the interface to be like this:
     
     ChatSequence.scheduleFor(date) ->
     
     If you implement some sort of protocol like ChatSequenceProvidor
     
     ChatSequenceProvidor {
     
        func provideSequence(for id: String) -> ChatSequence {
        
     
        }
     }
     
     
     
     */
    
    func start() {
        GMLogger.shared.log(.module(ChatKit.self), "Starting chat sequence: \(id)")
        analyticEventBlock?(.started)
        continueChat()
        startTime = Date()
    }
    
    private func next() -> Chat? {
        if chats.count > 0 {
            let first = chats.removeFirst()
            return first
        }
        return nil
    }
    
    func nextChat() -> Chat? {
        return chats.first
    }
    
    func continueChat() {
        let next = self.next()
        var nextMessage = next?.message ?? ""
        let estimatedReadingTime = readingTime(nextMessage)
        if let previousAnswer = previousAnswer {
            nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
        }
        
        if let chatMessage = next as? ChatMessage {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.continueChat()
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatMessage.type, message: chatMessage.message)))
            
        } else if let chatRandomMessage = next as? ChatRandomMessage {
            self.addMessage?(nextMessage)
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.continueChat()
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatRandomMessage.type, message: chatRandomMessage.message)))
            
        } else if let chatUserMessage = next as? ChatUserMessage {
            self.addUserMessage?(nextMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.continueChat()
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatUserMessage.type, message: chatUserMessage.message)))
            
        } else if let chatMessageConditional = next as? ChatMessageConditional {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.showButtons?(chatMessageConditional)
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatMessageConditional.type, message: chatMessageConditional.message)))
            
        } else if let chatButtons = next as? ChatButtons {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (estimatedReadingTime / 2.0)) {
                self.stopTyping?()
                self.showButtons?(chatButtons)
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatButtons.type, message: chatButtons.message)))
            
        } else if let chatButton = next as? ChatButton {
            if nextMessage != "" {
                self.addMessage?(nextMessage)
            }
            self.startTyping?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (estimatedReadingTime / 2.0)) {
                self.stopTyping?()
                self.showButtons?(chatButton)
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatButton.type, message: chatButton.message)))
            
        } else if let chatShowCancelButton = next as? ChatShowCancelButton {
            self.showCancelButton?()
            self.continueChat()
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatShowCancelButton.type, message: nil)))
            
        } else if let chatFallingEmojis = next as? ChatFallingEmojis {
            FallingEmojiView.shared.show(emoji: chatFallingEmojis.emoji)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
                self.continueChat()
            }
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatFallingEmojis.type, message: chatFallingEmojis.emoji)))
            
        } else if let chatDismiss = next as? ChatDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + chatDismiss.after) { [unowned self] in
                self.dismiss?()
                self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatDismiss.type, message: nil)))
            }
            
        } else if let chatDelay = next as? ChatDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + chatDelay.delay) { [unowned self] in
                self.continueChat()
                self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatDelay.type, message: "\(chatDelay.delay)")))
            }
            
        } else if let chatLoopStart = next as? ChatLoopStart {
            self.continueChat()
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatLoopStart.type, message: nil)))
            
        } else if let chatLoopEnd = next as? ChatLoopEnd {
            if let indexOfStart = self.allChats.firstIndex(where: { ($0 as? ChatLoopStart)?.id == chatLoopEnd.id }) {
                self.chats = Array(self.allChats[indexOfStart..<self.allChats.count])
                self.continueChat()
                self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatLoopEnd.type, message: nil)))
            }
        } else if let chatRunLogic = next as? ChatRunLogic, let controller = controller {
            chatRunLogic.block(controller)
            self.continueChat()
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatRunLogic.type, message: nil)))
            
        } else if let chatOpenURL = next as? ChatOpenURL {
            self.openURL?(chatOpenURL.url, chatOpenURL.withSafariVC)
            self.continueChat()
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatOpenURL.type, message: chatOpenURL.url.absoluteString)))
            
        } else if let chatTextInput = next as? ChatTextInput {
            self.addMessage?(nextMessage)
            self.startTyping?()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                self.stopTyping?()
                self.showTextInput?(chatTextInput)
            }
            
            self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatTextInput.type, message: chatTextInput.message)))
        } else {
            if self.levels.count > 0 {
                self.chats = self.levels.removeLast()
                self.continueChat()
            } else {
                GMLogger.shared.log(.module(ChatKit.self), "Complete chat sequence: \(id)")
                let elapsedTime = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
                self.analyticEventBlock?(ChatAnalyticEvent.finished(elapsedTime))
            }
        }
    }
    
    func userTappedButton(index: Int, buttonText: String, chat: Chat, controller: ChatViewController) {
        self.hideButtons?()
        self.previousAnswer = buttonText
        
        if let chat = chat as? ChatMessageConditional {
            let userMessage = chat.options[index]
            self.addUserMessage?(userMessage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + readingTime(userMessage)) {
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
        
        self.analyticEventBlock?(ChatAnalyticEvent.buttonPressed(ChatButtonAnalytic(type: chat.type, chat: chat.message, selectedButton: buttonText)))
    }
    
    func userEnteredText(text: String, chat: Chat, controller: ChatViewController) {
        self.previousAnswer = text
        self.addUserMessage?(text)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + readingTime(text) + 1.0) {
            self.continueChat()
        }
        
        self.analyticEventBlock?(ChatAnalyticEvent.textEntered(ChatTextInputAnalytic(text: text, chat: chat.message)))
    }
    
    func dismissed() {
        let elapsedTime = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
        self.analyticEventBlock?(ChatAnalyticEvent.dimissed(elapsedTime))
    }
    
    internal func readingTime(_ string: String) -> Double {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = string.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        
        return (1 + Double(words.count) * 0.2) / readingSpeed
    }
}
