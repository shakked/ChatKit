//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatMessageConditional: Chat {
    public let message: String
    public let options: [String]
    public let childChats: [[Chat]]
        
    public init(_ message: String = "", options: [ChatOption]) {
        self.message = message
        self.options = options.map({ $0.option })
        self.childChats = options.map({ $0.chats })
    }
}
