//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import Foundation

public struct ChatOption {
    public let option: String
    public let chats: [Chat]
    
    public init(_ option: String, chats: [Chat]) {
        self.option = option
        self.chats = chats
    }
}

