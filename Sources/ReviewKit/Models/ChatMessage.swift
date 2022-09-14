//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public protocol Chat {
    var message: String { get }
    var numberOfWords: Int { get }
    var estimatedReadTime: TimeInterval { get }
}

public extension Chat {
    var numberOfWords: Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = message.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
    
    var estimatedReadTime: TimeInterval {
        return 1 + Double(numberOfWords) * 0.2
    }
}

public struct ChatMessage: Chat {
    public let message: String
    
    
    public init(message: String) {
        self.message = message
    }
}

public struct UserChatMessage: Chat {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}

public struct ChatMessageConditional: Chat {
    public let message: String
    public let options: [String]
    public let childChats: [[Chat]]
        
    public init(message: String, options: [String], childChats: [[Chat]]) {
        self.message = message
        self.options = options
        self.childChats = childChats
    }
}

extension String {
    func estimatedReadingTime() -> TimeInterval {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return 1 + Double(words.count) * 0.2
    }
}

public class ChatSequence {
    
    var chats: [Chat]
    
    var levels: [[Chat]] = []
    
    var addMessage: ((String) -> ())? = nil
    var addUserMessage: ((String) -> ())? = nil
    var showButtons: ((ChatMessageConditional) -> ())? = nil
    var hideButtons: (() -> ())? = nil
    
    var isWaitingForButtonPressed: Bool = false
    
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
    
    private func continueChat(previousAnswer: String? = nil) {
        let next = self.next()
        var nextMessage = next?.message ?? ""
        if let previousAnswer = previousAnswer {
            nextMessage = nextMessage.replacingOccurrences(of: "%@", with: previousAnswer)
        }
        
        if let next = next as? ChatMessage {
            self.addMessage?(nextMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + next.estimatedReadTime) {
                self.continueChat()
            }
        } else if let next = next as? UserChatMessage {
            self.addUserMessage?(nextMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + next.estimatedReadTime) {
                self.continueChat()
            }
        } else if let next = next as? ChatMessageConditional {
            self.addMessage?(nextMessage)
            self.showButtons?(next)
        } else {
            if self.levels.count > 0 {
                self.chats = self.levels.removeLast()
                self.continueChat()
            } else {
                print("Nothing Left")
            }
        }
    }
    
    func userTappedButton(index: Int, buttonText: String, chat: ChatMessageConditional) {
        let userMessage = chat.options[index]
        self.addUserMessage?(userMessage)

        DispatchQueue.main.asyncAfter(deadline: .now() + userMessage.estimatedReadingTime()) {
            if chat.childChats.count > 0 {
                self.levels.append(self.chats)
                let nextChats = chat.childChats.count == 1 ? chat.childChats.first! : chat.childChats[index]
                self.chats = nextChats
                self.continueChat(previousAnswer: buttonText)
            } else {
                self.continueChat()
            }
        }
    }
}
