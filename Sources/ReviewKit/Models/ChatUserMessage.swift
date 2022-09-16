//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatUserMessage: Chat {
    public let message: String
    public init(_ message: String) {
        self.message = message
    }
}
