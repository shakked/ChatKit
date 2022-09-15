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
        
    public init(message: String, options: [(String, [Chat])]) {
        self.message = message
        self.options = options.map({ $0.0 })
        self.childChats = options.map({ $0.1 })
    }
}
