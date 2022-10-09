//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import Foundation

public struct ChatTextValidator: JSONObject {
    let regex: String
    let errorMessage: String?
    
    public init(regex: String, errorMessage: String?) {
        self.regex = regex
        self.errorMessage = errorMessage
        let _ = self.validate(text: "")
    }
    
    init(json: JSON) {
        self.regex = json["regex"].stringValue
        self.errorMessage = json["errorMessage"].string
    }
    
    var jsonDictionary: [String : Any] {
        if let errorMessage = errorMessage {
            return [
                "regex": regex,
                "errorMessage": errorMessage
            ]
        } else {
            return [
                "regex": regex,
            ]
        }
    }
    
    public func validate(text: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = test.evaluate(with: text)
        return isValid
    }
    
    public static func email() -> ChatTextValidator {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let errorMessage = "Please enter a valid email address."
        return ChatTextValidator(regex: emailRegEx, errorMessage: errorMessage)
    }
    
    public static func phoneNumber() -> ChatTextValidator {
        let phoneRegEx = "\\d{3}-\\d{3}-\\d{4}$"
        let errorMessage = "Please enter a valid phone number."
        return ChatTextValidator(regex: phoneRegEx, errorMessage: errorMessage)
    }
    
    public static func length(atLeast: Int, maximum: Int) -> ChatTextValidator {
        let emailRegEx = "[ A-Z0-9a-z._%+-@]{\(atLeast),\(maximum)}+"
        let errorMessage = "Please enter a few words"
        return ChatTextValidator(regex: emailRegEx, errorMessage: errorMessage)
    }
}
