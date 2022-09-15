//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

public struct ChatDismiss: Chat {
    public var message: String = ""
    public let after: TimeInterval
    public init(after: TimeInterval = 0.0) {
        self.after = after
    }
}
