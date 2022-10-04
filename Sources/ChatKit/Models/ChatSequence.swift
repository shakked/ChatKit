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
    var showButtons: ((ChatMessageConditional) -> ())? = nil
    var showTextInput: ((ChatTextInput) -> ())? = nil
    var hideButtons: (() -> ())? = nil
    var showCancelButton: (() -> ())? = nil
    var dismiss: (() -> ())? = nil
    var startTyping: (() -> ())? = nil
    var stopTyping: (() -> ())? = nil
    
    var isWaitingForButtonPressed: Bool = false
    var previousAnswer: String?
    var startTime: Date = Date()
    
    var isStopped: Bool = false
        
    public init(id: String, chats: [Chat]) {
        self.id = id
        self.chats = chats
        self.allChats = chats
        
        GitMart.shared.confirmAccessToProject(library: ChatKit.self)
        ChatKit.shared.registerChatSequence(sequence: self)
    }
    
    public init(json: JSON) {
        self.id = json["id"].stringValue
        self.chats = json["chats"].arrayValue.map({ AnyChat.chat(for: $0) }).compactMap({ $0 })
        self.allChats = self.chats
        
        if let readingSpeed = json["readingSpeed"].double {
            self.readingSpeed = readingSpeed
        }
    }
    
    public var json: String {
        let sequenceObject: [String: Any] = [
            "id": id,
            "readingSpeed": readingSpeed,
            "chats": chats.map({ $0.json })
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: sequenceObject, options: .prettyPrinted)
        let string = String(data: data, encoding: .utf8)!
        return string
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
    
    func stop() {
        isStopped = true
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
        guard !isStopped else {
            self.chats = []
            return
        }
        
        GMLogger.shared.log(.module(ChatKit.self), "Next Chat: \(nextChat()?.type.description ?? "")")
        guard let next = self.next() else {
            if self.levels.count > 0 {
                self.chats = self.levels.removeLast()
                self.continueChat()
            } else {
                GMLogger.shared.log(.module(ChatKit.self), "Complete chat sequence: \(id)")
                let elapsedTime = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
                self.analyticEventBlock?(ChatAnalyticEvent.finished(elapsedTime))
            }
            return
        }
        
        switch next.type {
        case .chatMessage:
            if let chatMessage = next as? ChatMessage {
                var nextMessage = chatMessage.message
                if let previousAnswer = previousAnswer {
                    nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
                }
                let estimatedReadingTime = readingTime(nextMessage)
                
                self.addMessage?(nextMessage)
                self.startTyping?()
                DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                    self.stopTyping?()
                    self.continueChat()
                }
                self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatMessage.type, message: chatMessage.message)))
            }
        case .chatUserMessage:
            if let chatUserMessage = next as? ChatUserMessage {
                var nextMessage = chatUserMessage.message
                if let previousAnswer = previousAnswer {
                    nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
                }
                let estimatedReadingTime = readingTime(nextMessage)
                self.addUserMessage?(nextMessage)
                DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                    self.continueChat()
                }
            }
        case .chatMessageConditional:
            if let chatMessageConditional = next as? ChatMessageConditional {
                self.showButtons?(chatMessageConditional)
            }
        case .chatRandomMessage:
            if let chatRandomMessage = next as? ChatRandomMessage {
                let nextMessage = chatRandomMessage.message
                let estimatedReadingTime = readingTime(nextMessage)
                self.addMessage?(nextMessage)
                self.startTyping?()
                DispatchQueue.main.asyncAfter(deadline: .now() + estimatedReadingTime) {
                    self.stopTyping?()
                    self.continueChat()
                }
                self.analyticEventBlock?(ChatAnalyticEvent.chatExecuted(ChatAnalytic(type: chatRandomMessage.type, message: chatRandomMessage.message)))
            }
        case .chatTextInput:
            if let chatTextInput = next as? ChatTextInput {
                self.showTextInput?(chatTextInput)
            }
            
        case .chatInstruction:
            if let chatInstruction = next as? ChatInstruction {
                switch chatInstruction.action {
                case .openURL(let url, let showInSafari):
                    GitMart.shared.delegate?.handleAction(library: ChatKit.self, action: .openURL(url, showInSafari), controller: controller)
                    self.continueChat()
                    
                case .showCancelButton:
                    self.showCancelButton?()
                    self.continueChat()
                    
                    
                case .rainingEmojis(let emoji):
                    FallingEmojiView.shared.show(emoji: emoji)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
                        self.continueChat()
                    }
                    
                    
                case .other(let action):
                    break
                case .contactSupport:
                    break
                case .delay(let delay):
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
                        self.continueChat()
                    }
                case .dismiss:
                    self.dismiss?()
                    
                case .loopStart(let id):
                    self.continueChat()
                    
                case .loopEnd(let id):
                    if let indexOfStart = self.allChats.firstIndex(where: { ($0 as? ChatInstruction)?.action.loopID == id }) {
                        self.chats = Array(self.allChats[indexOfStart..<self.allChats.count])
                        self.continueChat()
                        
                    }
                case .requestRating:
                    GitMart.shared.delegate?.handleAction(library: ChatKit.self, action: .requestRating, controller: controller)
                    self.continueChat()
                    
                case .requestWrittenReview:
                    GitMart.shared.delegate?.handleAction(library: ChatKit.self, action: .requestWrittenReview, controller: controller)
                    self.continueChat()
                case .purchaseProduct(let product):
                    break
                case .restorePurchases:
                    break
                }
            }
            break
        }
    }

    func userTappedButton(index: Int, buttonText: String, chat: Chat, controller: ChatViewController) {
        self.hideButtons?()
        self.previousAnswer = buttonText
        
        if let chat = chat as? ChatMessageConditional {
            let userMessage = chat.options[index].option
            self.addUserMessage?(userMessage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + readingTime(userMessage)) {
                if chat.options.count > 0 {
                    self.levels.append(self.chats)
                    let selectedOption = chat.options[index]
                    self.chats = selectedOption.chats
                    self.continueChat()
                } else {
                    self.continueChat()
                }
            }
        }
    }
    
    func userEnteredText(text: String, chat: Chat, controller: ChatViewController) {
        self.previousAnswer = text
        self.addUserMessage?(text)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + readingTime(text) + 1.0) {
            self.continueChat()
        }        
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
