//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/22/22.
//

import Foundation

public enum ChatAnalyticEvent {
    case started
    case finished(TimeInterval)
    case dimissed(TimeInterval)
    case buttonPressed(ChatButtonAnalytic)
    case textEntered(ChatTextInputAnalytic)
    case chatExecuted(ChatAnalytic)
}

public struct ChatButtonAnalytic {
    public let type: ChatType
    public let chat: String
    public let selectedButton: String
}

public struct ChatAnalytic {
    public let type: ChatType
    public let message: String?
}

public struct ChatTextInputAnalytic {
    public let text: String
    public let chat: String
}
