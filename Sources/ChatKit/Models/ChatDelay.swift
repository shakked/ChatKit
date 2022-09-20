//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/20/22.
//

import Foundation

public struct ChatDelay: Chat {
    public let message: String = ""
    public let delay: TimeInterval
    
    public init(_ delay: TimeInterval) {
        self.delay = delay
    }
}
