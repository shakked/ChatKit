//
//  AnyChat.swift
//  
//
//  Created by Zachary Shakked on 10/4/22.
//

import Foundation

struct AnyChat {
    /*
        Concrect types like this can be used to initialize protocols from decodable objects
     */
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
