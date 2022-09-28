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
    public let contentType: UITextContentType
    
    public init(_ message: String, placeholder: String, validator: ChatTextValidator, keyboardType: UIKeyboardType, returnKey: UIReturnKeyType, contentType: UITextContentType) {
        self.message = message
        self.placeholder = placeholder
        self.validator = validator
        self.keyboardType = keyboardType
        self.returnKey = returnKey
        self.contentType = contentType
    }
    
    public static var email: ChatTextInput {
        return ChatTextInput("What is your email?", placeholder: "i.e. john@gmail.com", validator: ChatTextValidatorEmail(), keyboardType: .emailAddress, returnKey: .next, contentType: .emailAddress)
    }
    
    public static var firstName: ChatTextInput {
        return ChatTextInput("What is your first name?", placeholder: "i.e. John", validator: ChatTextValidatorLength(length: 1,
                                                                                                                      greaterThan: true,
                                                                                                                      errorMessage: "Please enter your first name."), keyboardType: .default, returnKey: .next, contentType: .givenName)
    }
    
    public static var lastName: ChatTextInput {
        return ChatTextInput("What is your last name?", placeholder: "i.e. Handcock", validator: ChatTextValidatorLength(length: 1,
                                                                                                                      greaterThan: true,
                                                                                                                         errorMessage: "Please enter your last name."), keyboardType: .default, returnKey: .next, contentType: .familyName)
    }
    
    
    
}

