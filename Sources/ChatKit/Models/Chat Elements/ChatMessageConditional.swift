//
//  ChatMessageConditional.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatMessageConditional: Chat {
    public let options: [ChatOption]
        
    public init(options: [ChatOption]) {
        self.options = options
    }
    
    public init(json: JSON) {
        self.options = json["options"].arrayValue.map({ ChatOption(json: $0) })
    }
    
    public var json: [String : Any] {
        return [
            "chat": "chatMessageConditional",
            "options": options.map({ $0.json })
        ]
    }
}
