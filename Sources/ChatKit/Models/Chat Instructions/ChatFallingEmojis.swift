//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

public struct ChatFallingEmojis: Chat {
    public let message: String = ""
    public let emoji: String
    public init(emoji: String) {
        self.emoji = emoji
    }
}
