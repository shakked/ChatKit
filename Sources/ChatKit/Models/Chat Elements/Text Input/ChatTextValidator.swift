//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import Foundation

public protocol ChatTextValidator {
    var errorMessage: String? { get }
    func validate(text: String) -> Bool
}

public struct ChatTextValidatorLength: ChatTextValidator {
    public let length: Int
    public let greaterThan: Bool
    public let errorMessage: String?
    public init(length: Int, greaterThan: Bool, errorMessage: String?) {
        self.length = length
        self.greaterThan = greaterThan
        self.errorMessage = errorMessage
    }
    
    public func validate(text: String) -> Bool {
        if greaterThan {
            return text.count > length
        } else {
            return text.count < length
        }
    }
}

public struct ChatTextValidatorRegex: ChatTextValidator {
    public let regex: String
    public let errorMessage: String?
    public init(regex: String, errorMessage: String) {
        self.regex = regex
        self.errorMessage = errorMessage
        let _ = self.validate(text: "")
    }
    
    public func validate(text: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = test.evaluate(with: text)
        return isValid
    }
}

public struct ChatTextValidatorEmail: ChatTextValidator {
    public let errorMessage: String? = "Please enter a valid email address."
    
    public func validate(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailTest.evaluate(with: text)
        return isValid
    }
    
    public init() {
        
    }
}
