//
//  ChatInstruction.swift
//  
//
//  Created by Zachary Shakked on 10/1/22.
//

import Foundation

public struct ChatInstruction: Chat, JSONObject {
    public let action: ChatAction
    public init(_ action: ChatAction) {
        self.action = action
    }
    
    init(json: JSON) {
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
    
    public var jsonDictionary: [String : Any] {
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
