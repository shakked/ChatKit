//
//  ChatTextInput.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import UIKit

public struct ChatTextInput: Chat {
    public let placeholder: String
    public let validator: ChatTextValidator
    public let keyboardType: UIKeyboardType
    public let returnKey: UIReturnKeyType
    public let contentType: UITextContentType?
    
    public init(placeholder: String, validator: ChatTextValidator, keyboardType: UIKeyboardType, returnKey: UIReturnKeyType, contentType: UITextContentType) {
        self.placeholder = placeholder
        self.validator = validator
        self.keyboardType = keyboardType
        self.returnKey = returnKey
        self.contentType = contentType
    }
    
    enum CodingKeys: String, CodingKey {
        case message
        case placeholder
        case validator
        case keyboardType
        case returnKey
        case contentType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.placeholder = try container.decode(String.self, forKey: .placeholder)
        self.validator = try container.decode(ChatTextValidator.self, forKey: .validator)
        if let keyboardType = try? container.decode(String.self, forKey: .keyboardType) {
            self.keyboardType = UIKeyboardType(type: keyboardType) ?? .default
        } else {
            self.keyboardType = .default
        }
        if let returnKey = try? container.decode(String.self, forKey: .returnKey) {
            self.returnKey = UIReturnKeyType(type: returnKey) ?? .`default`
        } else {
            self.returnKey = .`default`
        }
        if let contentType = try? container.decode(String.self, forKey: .contentType) {
            self.contentType = UITextContentType(type: contentType)
        } else {
            self.contentType = nil
        }
    }
    
    public init(json: JSON) {
        self.placeholder = json["placeholder"].stringValue
        self.validator = ChatTextValidator(json: json["validator"])
        self.keyboardType = UIKeyboardType(type: json["keyboardType"].stringValue) ?? .`default`
        self.returnKey = UIReturnKeyType(type: json["returnKey"].stringValue) ?? .`default`
        self.contentType = UITextContentType(type: json["contentType"].stringValue)
    }
    
    public var json: [String : Any] {
        var theJSON: [String: Any] = [
            "chat": "chatTextInput",
            "validator": [
                "regex": validator.regex
            ],
            "keyboardType": keyboardType.rawValueString,
            "returnKey": returnKey.rawValueString,
        ]
        
        if let errorMessage = validator.errorMessage {
            theJSON["validator"] = [
                "regex": validator.regex,
                "errorMessage": errorMessage
            ]
        }
        
        if let contentType {
            theJSON["contentType"] = contentType
        }
        
        return theJSON
    }
}

extension UIKeyboardType {
    public init?(type: String) {
        switch type {
        case "default":
            self = .`default`
        case "asciiCapable":
            self = .asciiCapable
        case "numbersAndPunctuation":
            self = .numbersAndPunctuation
        case "URL":
            self = .URL
        case "numberPad":
            self = .numberPad
        case "phonePad":
            self = .phonePad
        case "namePhonePad":
            self = .namePhonePad
        case "emailAddress":
            self = .emailAddress
        case "decimalPad":
            self = .decimalPad
        case "twitter":
            self = .twitter
        case "webSearch":
            self = .webSearch
        case "asciiCapableNumberPad":
            self = .asciiCapableNumberPad
        default:
            return nil
        }
    }
    
    public var rawValueString: String {
        switch self {
        case .`default`:
            return "default"
        case .asciiCapable:
            return "asciiCapable"
        case .numbersAndPunctuation:
            return "numbersAndPunctuation"
        case .URL:
            return "URL"
        case .numberPad:
            return "numberPad"
        case .phonePad:
            return "phonePad"
        case .namePhonePad:
            return "namePhonePad"
        case .emailAddress:
            return "emailAddress"
        case .decimalPad:
            return "decimalPad"
        case .twitter:
            return "twitter"
        case .webSearch:
            return "webSearch"
        case .asciiCapableNumberPad:
            return "asciiCapableNumberPad"
        case .alphabet:
            return "alphabet"
        }
    }
}

extension UIReturnKeyType {
    public init?(type: String) {
        switch type {
        case "default":
            self = .`default`
        case "go":
            self = .go
        case "google":
            self = .google
        case "join":
            self = .join
        case "next":
            self = .next
        case "route":
            self = .route
        case "search":
            self = .search
        case "send":
            self = .send
        case "yahoo":
            self = .yahoo
        case "done":
            self = .done
        case "emergencyCall":
            self = .emergencyCall
        case "continue":
            self = .continue
        default:
            return nil
        }
    }
    
    public var rawValueString: String {
        switch self {
        case .`default`:
            return "default"
        case .go:
            return "go"
        case .google:
            return "google"
        case .join:
            return "join"
        case .next:
            return "next"
        case .route:
            return "route"
        case .search:
            return "search"
        case .send:
            return "send"
        case .yahoo:
            return "yahoo"
        case .done:
            return "done"
        case .emergencyCall:
            return "emergencyCall"
        case .continue:
            return "continue"
        default:
            return "default"
        }
    }
}

extension UITextContentType {
    public init?(type: String) {
        switch type {
        case "name":
            self = .name
        case "namePrefix":
            self = .namePrefix
        case "givenName":
            self = .givenName
        case "middleName":
            self = .middleName
        case "familyName":
            self = .familyName
        case "nameSuffix":
            self = .nameSuffix
        case "nickname":
            self = .nickname
        case "jobTitle":
            self = .jobTitle
        case "organizationName":
            self = .organizationName
        case "location":
            self = .location
        case "fullStreetAddress":
            self = .fullStreetAddress
        case "streetAddressLine1":
            self = .streetAddressLine1
        case "streetAddressLine2":
            self = .streetAddressLine2
        case "addressCity":
            self = .addressCity
        case "addressState":
            self = .addressState
        case "addressCityAndState":
            self = .addressCityAndState
        case "sublocality":
            self = .sublocality
        case "countryName":
            self = .countryName
        case "postalCode":
            self = .postalCode
        case "telephoneNumber":
            self = .telephoneNumber
        case "emailAddress":
            self = .emailAddress
        case "URL":
            self = .URL
        case "creditCardNumber":
            self = .creditCardNumber
        case "username":
            self = .username
        case "password":
            self = .password
        case "newPassword":
            self = .newPassword
        case "oneTimeCode":
            self = .oneTimeCode
        case "shipmentTrackingNumber":
            if #available(iOS 15.0, *) {
                self = .shipmentTrackingNumber
            } else {
                return nil
            }
        case "flightNumber":
            if #available(iOS 15.0, *) {
                self = .flightNumber
            } else {
                return nil
            }
        case "dateTime":
            if #available(iOS 15.0, *) {
                self = .dateTime
            } else {
                return nil
            }
        default:
            return nil
        }
    }
}
