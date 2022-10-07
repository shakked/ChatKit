//
//  ChatUserMessage.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatUserMessage: Chat, JSONObject {
    public let message: String
    public init(_ message: String) {
        self.message = message
    }
    
    init(json: JSON) {
        self.message = json["message"].stringValue
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "chat": "chatUserMessage",
            "message": message,
        ]
    }
}
