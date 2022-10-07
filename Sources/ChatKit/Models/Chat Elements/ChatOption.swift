//
//  ChatOption.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import UIKit

public struct ChatOption: JSONObject {
    public let option: String
    public let sfSymbolName: String?
    public let chats: [Chat]
    
    public init(_ option: String, sfSymbolName: String? = nil, chats: [Chat]) {
        self.option = option
        self.sfSymbolName = sfSymbolName
        self.chats = chats
    }
    
    init(json: JSON) {
        self.option = json["option"].stringValue
        self.sfSymbolName = json["sfSymbolName"].stringValue
        self.chats = json["chats"].arrayValue.map({ AnyChat.chat(for: $0) }).compactMap({ $0 })
    }
    
    var jsonDictionary: [String: Any] {
        var theJSON: [String: Any] = [
            "option": option,
            "chats": chats.map({ ($0 as? JSONObject)?.jsonDictionary }).compactMap({ $0 })
        ]
        
        if let sfSymbolName = sfSymbolName {
            theJSON["sfSymbolName"] = sfSymbolName
        }
        
        return theJSON
    }
}

