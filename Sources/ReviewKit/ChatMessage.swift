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
    public let appearsAfter: TimeInterval
    
    public init(message: String, appearsAfter: TimeInterval) {
        self.message = message
        self.appearsAfter = appearsAfter
    }
}

public struct ChatMessageConditional: Chat {
    public let message: String
    public let appearsAfter: TimeInterval
    public let hasButton: Bool
    public let buttonSFIcon: String
    public let options: [String]
    public let childChats: [[Chat]]
    
    public init(message: String, appearsAfter: TimeInterval, hasButton: Bool = false, buttonSFIcon: String = "pencil", options: [String], childChats: [[Chat]]) {
        self.message = message
        self.appearsAfter = appearsAfter
        self.hasButton = hasButton
        self.buttonSFIcon = buttonSFIcon
        self.options = options
        self.childChats = childChats
    }
}

class ChatSequence {
    
    var chats: [Chat]
    
    init(chats: [Chat]) {
        self.chats = chats
    }
    
    func next() -> Chat? {
        if chats.count > 0 {
            let first = chats.removeFirst()
            return first
        }
        return nil
    }
    
}
