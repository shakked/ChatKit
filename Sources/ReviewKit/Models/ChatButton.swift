//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

public struct ChatButton: Chat {
    public let message: String
    public let buttons: [ButtonIngredients]
    public init(message: String, buttons: [ButtonIngredients]) {
        self.message = message
        self.buttons = buttons
    }
}
