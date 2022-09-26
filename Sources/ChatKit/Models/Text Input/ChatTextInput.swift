//
//  ChatTextInput.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import UIKit

public struct ChatTextInput: Chat {
    public let message: String
    public let placeholder: String
    public let validator: ChatTextValidator
    public let keyboardType: UIKeyboardType
    public let returnKey: UIReturnKeyType
    
    public init(_ message: String, placeholder: String, validator: ChatTextValidator, keyboardType: UIKeyboardType, returnKey: UIReturnKeyType) {
        self.message = message
        self.placeholder = placeholder
        self.validator = validator
        self.keyboardType = keyboardType
        self.returnKey = returnKey
    }
}

