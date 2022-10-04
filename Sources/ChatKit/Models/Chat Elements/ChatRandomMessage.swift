//
//  ChatRandomMessage.swift
//  
//
//  Created by Zachary Shakked on 9/20/22.
//

import Foundation

public struct ChatRandomMessage: Chat {
    public var message: String {
        return messages.randomElement() ?? ""
    }
    public let messages: [String]
    public init(_ messages: [String]) {
        self.messages = messages
    }
    
    public init(json: JSON) {
        self.messages = json["messages"].arrayValue.map({ $0.stringValue })
    }
    
    public var json: [String : Any] {
        return [
            "chat": "chatRandomMessage",
            "messages": messages
        ]
    }
}
