//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

public struct ChatButtons: Chat {
    public let message: String
    public let buttons: [ChatButton]
    public init(_ message: String = "", buttons: [ChatButton]) {
        self.message = message
        self.buttons = buttons
    }
}
