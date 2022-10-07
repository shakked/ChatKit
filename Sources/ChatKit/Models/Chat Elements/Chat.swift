//
//  Chat.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public protocol Chat  {
    var type: ChatType { get }
}

public extension Chat {
    var type: ChatType {
        let typeString = String(describing: Self.self)
        return ChatType(chatType: typeString)!
    }
}

public enum ChatType {
    case chatMessage
    case chatUserMessage
    case chatRandomMessage
    case chatMessageConditional
    case chatInstruction
    case chatTextInput
    
    init?(chatType: String) {
        switch chatType.lowercased() {
        case "chatMessage".lowercased():
            self = .chatMessage
        case "chatUserMessage".lowercased():
            self = .chatUserMessage
        case "chatRandomMessage".lowercased():
            self = .chatRandomMessage
        case "chatMessageConditional".lowercased():
            self = .chatMessageConditional
        case "chatInstruction".lowercased():
            self = .chatInstruction
        case "chatTextInput".lowercased():
            self = .chatTextInput
        case "chatInstruction".lowercased():
            self = .chatInstruction
        default:
            return nil
        }
    }
    
    var description: String {
        switch self {
        case .chatMessage:
            return "chatMessage"
        case .chatUserMessage:
            return "chatUserMessage"
        case .chatRandomMessage:
            return "chatRandomMessage"
        case .chatMessageConditional:
            return "chatMessageConditional"
        case .chatInstruction:
            return "chatInstruction"
        case .chatTextInput:
            return "chatTextInput"
        }
    }
}
