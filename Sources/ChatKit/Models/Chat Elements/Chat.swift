//
//  Chat.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public protocol Chat  {
    var type: ChatType { get }
    init(json: JSON)
    
    var json: [String: Any] { get }
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
    
    public init?(chatType: String) {
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
    
    public var description: String {
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

//public struct AnyChat: Chat, Decodable {
//
//    public let type: String
//    public let message: String = ""
//    public let wrapped: Chat
//
//    enum CodingKeys: String, CodingKey {
//        case type
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        type = try container.decode(String.self, forKey: .type)
//        switch type {
//        case "ChatButton":
//            wrapped = try ChatMessage(from: decoder)
//        case "ChatButtons":
//            wrapped = try ChatButtons(from: decoder)
//        case "ChatMessage":
//            wrapped = try ChatMessage(from: decoder)
//        case "ChatUserMessage":
//            wrapped = try ChatUserMessage(from: decoder)
//        case "ChatRandomMessage":
//            wrapped = try ChatRandomMessage(from: decoder)
//        case "ChatMessageConditional":
//            wrapped = try ChatMessageConditional(from: decoder)
//        case "ChatDelay":
//            wrapped = try ChatDelay(from: decoder)
//        case "ChatDismiss":
//            wrapped = try ChatDismiss(from: decoder)
//        case "ChatFallingEmojis":
//            wrapped = try ChatFallingEmojis(from: decoder)
//        case "ChatLoopStart":
//            wrapped = try ChatLoopStart(from: decoder)
//        case "ChatOpenURL":
//            wrapped = try ChatOpenURL(from: decoder)
//        case "ChatRequestRating":
//            wrapped = try ChatRequestRating(from: decoder)
//        case "ChatRequestWrittenReview":
//            wrapped = try ChatRequestWrittenReview(from: decoder)
//        case "ChatShowCancelButton":
//            wrapped = try ChatShowCancelButton(from: decoder)
//        default:
//            fatalError()
//        }
//    }
//}
