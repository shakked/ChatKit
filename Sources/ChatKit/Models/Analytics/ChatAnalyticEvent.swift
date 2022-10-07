//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/22/22.
//

import Foundation

public enum ChatAnalyticEvent {
    case started(ChatSequence)
    case finished(ChatSequence, TimeInterval)
    case dimissed(ChatSequence, TimeInterval)
    case buttonPressed(ChatSequence, ChatButtonAnalytic)
    case textEntered(ChatSequence, ChatTextInputAnalytic)
    case instruction(ChatSequence, ChatAction)
    
    var eventName: String {
        switch self {
        case .started(_):
            return "Chat Started"
        case .finished(_, _):
            return "Chat Finished"
        case .dimissed(_, _):
            return "Chat Dismissed"
        case .buttonPressed(_, _):
            return "Chat Option Selected"
        case .textEntered(_, _):
            return "Chat Text Entered"
        case .instruction(_, _):
            return "Chat Instruction Ran"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .started(let chatSequence):
            return [
                "chat_id": chatSequence.id,
            ]
        case .finished(let chatSequence, let timeInterval):
            return [
                "chat_id": chatSequence.id,
                "duration": timeInterval
            ]
        case .dimissed(let chatSequence, let timeInterval):
            return [
                "chat_id": chatSequence.id,
                "duration": timeInterval
            ]
        case .buttonPressed(let chatSequence, let chatButtonAnalytic):
            return [
                "chat_id": chatSequence.id,
                "selected_option": chatButtonAnalytic.selectedOption,
                "question": chatButtonAnalytic.chat.message,
            ]
        case .textEntered(let chatSequence, let chatTextInputAnalytic):
            return [
                "chat_id": chatSequence.id,
                "question": chatTextInputAnalytic.chat.message,
                "entered_text": chatTextInputAnalytic.enteredText,
            ]
        case .instruction(let chatSequence, let action):
            return [
                "chat_id": chatSequence.id,
                "instruction": action.name,
            ]
        }
    }
}

public struct ChatButtonAnalytic {
    public let chat: ChatMessageConditional
    public let selectedOption: String
}

public struct ChatAnalytic {
    public let type: ChatType
    public let message: String?
}

public struct ChatTextInputAnalytic {
    public let chat: ChatTextInput
    public let enteredText: String
}
