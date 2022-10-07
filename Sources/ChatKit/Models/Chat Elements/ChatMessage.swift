//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public struct ChatMessage: Chat, JSONObject {
    public let message: String
    public init(_ message: String) {
        self.message = message
    }
    
    init(json: JSON) {
        self.message = json["message"].stringValue
    }
    
    var jsonDictionary: [String : Any] {
        return [
            "chat": "chatMessage",
            "message": message
        ]
    }
}
