//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import Foundation

public struct ChatLoopStart: Chat {
    public let id: String
    public let message: String = ""
    public init(id: String) {
        self.id = id
    }
}

public struct ChatLoopEnd: Chat {
    public let id: String
    public let message: String = ""
    public init(id: String) {
        self.id = id
    }
}
