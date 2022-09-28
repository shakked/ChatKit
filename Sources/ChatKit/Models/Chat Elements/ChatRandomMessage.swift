//
//  File.swift
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
}
