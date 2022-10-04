//
//  ChatInstruction.swift
//  
//
//  Created by Zachary Shakked on 10/1/22.
//

import Foundation

public struct ChatInstruction: Chat {
    public let action: ChatAction
    public init(_ action: ChatAction) {
        self.action = action
    }
    
    public init(json: JSON) {
        let action = json["action"]["type"].stringValue
        switch action {
        case "purchaseProduct":
            let productID = json["action"]["productID"].stringValue
            self = ChatInstruction(.purchaseProduct(productID))
        case "restorePurchases":
            self = ChatInstruction(.restorePurchases)
        case "openURL":
            let urlString = json["action"]["url"].stringValue
            let inSafariVC = json["action"]["inSafariVC"].boolValue
            let url = URL(string: urlString)!
            self = ChatInstruction(.openURL(url, inSafariVC))
        case "requestRating":
            self = ChatInstruction(.requestRating)
        case "requestWrittenReview":
            self = ChatInstruction(.requestWrittenReview)
        case "contactSupport":
            self = ChatInstruction(.contactSupport)
        case "dismiss":
            self = ChatInstruction(.dismiss)
        case "showCancelButton":
            self = ChatInstruction(.showCancelButton)
        case "delay":
            let value = json["action"]["value"].doubleValue
            self = ChatInstruction(.delay(value))
        case "rainingEmojis":
            let emoji = json["action"]["emoji"].stringValue
            self = ChatInstruction(.rainingEmojis(emoji))
        case "loopStart":
            let loopID = json["action"]["loopID"].stringValue
            self = ChatInstruction(.loopStart(loopID))
        case "loopEnd":
            let loopID = json["action"]["loopID"].stringValue
            self = ChatInstruction(.loopEnd(loopID))
        default:
            self = ChatInstruction(.other(action))
        }
    }
    
    public var json: [String : Any] {
        switch action {
        case .purchaseProduct(let productID):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "purchaseProduct",
                    "productID": productID
                ]
            ]
        case .restorePurchases:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "restorePurchases",
                ]
            ]
        case .openURL(let url, let inSafariVC):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "openURL",
                    "url": url.absoluteString,
                    "inSafariVC": inSafariVC,
                ]
            ]
        case .requestRating:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "requestRating",
                ]
            ]
        case .requestWrittenReview:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "requestWrittenReview",
                ]
            ]
        case .contactSupport:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "contactSupport",
                ]
            ]
        case .other(let other):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": other,
                ]
            ]
        case .dismiss:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "dismiss",
                ]
            ]
        case .showCancelButton:
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "showCancelButton",
                ]
            ]
        case .delay(let timeInterval):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "delay",
                    "value": timeInterval,
                ]
            ]
        case .rainingEmojis(let emoji):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "rainingEmojis",
                    "emoji": emoji,
                ]
            ]
        case .loopStart(let loopID):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "loopStart",
                    "loopID": loopID,
                ]
            ]
        case .loopEnd(let loopID):
            return [
                "chat": "chatInstruction",
                "action": [
                    "type": "loopEnd",
                    "loopID": loopID,
                ]
            ]
        }
    }
}

public struct JSON {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    var stringValue: String {
        return value as? String ?? ""
    }
    var string: String? {
        return value as? String
    }
    
    var intValue: Int {
        return value as? Int ?? 0
    }
    var int: Int? {
        return value as? Int
    }
    
    var doubleValue: Double {
        return value as? Double ?? 0.0
    }
    
    var double: Double? {
        return value as? Double
    }
    
    var array: [JSON]? {
        if let array = value as? [Any] {
            return array.map(JSON.init)
        }
        return nil
    }
    
    var arrayValue: [JSON] {
        if let array = value as? [Any] {
            return array.map(JSON.init)
        }
        return []
    }
    
    var dictionary: [String: JSON]? {
        if let dictionary = value as? [String: Any] {
            var updatedDictionary: [String: JSON] = [:]
            dictionary.keys.forEach { key in
                if let value = dictionary[key] {
                    updatedDictionary[key] = JSON(value)
                }
            }
            return updatedDictionary
        }
        return nil
    }
    
    var dictionaryValue: [String: JSON] {
        if let dictionary = value as? [String: Any] {
            var updatedDictionary: [String: JSON] = [:]
            dictionary.keys.forEach { key in
                if let value = dictionary[key] {
                    updatedDictionary[key] = JSON(value)
                }
            }
            return updatedDictionary
        }
        return [:]
    }
    
    var boolValue: Bool {
        return value as? Bool ?? false
    }
    
    var bool: Bool? {
        return value as? Bool
    }
    
    subscript(_ key: String) -> JSON {
        if let value = value as? [String: Any], let keyValue = value[key] {
            return JSON(keyValue)
        }
        return JSON([:])
    }
}
