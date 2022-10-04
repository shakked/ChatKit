//
//  Trigger.swift
//  
//
//  Created by Zachary Shakked on 10/4/22.
//

import Foundation

struct Trigger {
    let event: String
    let chatSequenceID: String
    let count: Int
    
    init(json: JSON) {
        self.event = json["event"].stringValue
        self.chatSequenceID = json["chatSequenceID"].stringValue
        self.count = json["count"].intValue
    }
}
