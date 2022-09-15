//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct UserChatMessage: Chat {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}
