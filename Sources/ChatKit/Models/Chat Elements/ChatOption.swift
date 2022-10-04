//
//  ChatOption.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import UIKit

public struct ChatOption {
    public let option: String
    public let sfSymbolName: String?
    public let chats: [Chat]
    
    public init(_ option: String, sfSymbolName: String? = nil, chats: [Chat]) {
        self.option = option
        self.sfSymbolName = sfSymbolName
        self.chats = chats
    }
    
    public init(json: JSON) {
        self.option = json["option"].stringValue
        self.sfSymbolName = json["sfSymbolName"].stringValue
        self.chats = json["chats"].arrayValue.map({ AnyChat.chat(for: $0) }).compactMap({ $0 })
    }
    
    public var json: [String: Any] {
        var theJSON: [String: Any] = [
            "chat": "chatOption",
            "option": option,
            "chats": chats.map({ $0.json })
        ]
        
        if let sfSymbolName = sfSymbolName {
            theJSON["sfSymbolName"] = sfSymbolName
        }
        
        return theJSON
    }
}

struct AnyChat {
    static func chat(for json: JSON) -> Chat? {
        let type = json["chat"].stringValue
        guard let chatType = ChatType(chatType: type) else { return nil }
        switch chatType {
        case .chatMessage:
            return ChatMessage(json: json)
        case .chatUserMessage:
            return ChatUserMessage(json: json)
        case .chatRandomMessage:
            return ChatRandomMessage(json: json)
        case .chatMessageConditional:
            return ChatMessageConditional(json: json)
        case .chatInstruction:
            return ChatInstruction(json: json)
        case .chatTextInput:
            return ChatTextInput(json: json)
        }
    }
}
