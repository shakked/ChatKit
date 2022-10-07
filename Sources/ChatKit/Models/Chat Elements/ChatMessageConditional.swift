//
//  ChatMessageConditional.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatMessageConditional: Chat, JSONObject{
    public let message: String
    public let options: [ChatOption]
        
    public init(message: String, options: [ChatOption]) {
        self.message = message
        self.options = options
    }
    
    init(json: JSON) {
        self.message = json["message"].stringValue
        self.options = json["options"].arrayValue.map({ ChatOption(json: $0) })
    }
    
    public var jsonDictionary: [String : Any] {
        return [
            "chat": "chatMessageConditional",
            "message": message,
            "options": options.map({ $0.jsonDictionary })
        ]
    }
}
