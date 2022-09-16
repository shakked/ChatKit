//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public struct ChatMessage: Chat {
    public let message: String
    public init(_ message: String) {
        self.message = message
    }
}
