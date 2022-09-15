//
//  ChatContinueButton.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

public struct ChatContinueButton: Chat {
    public let message: String = ""
    public let button: ButtonIngredients
    public init(button: ButtonIngredients? = nil) {
        if let button = button {
            self.button = button
        } else {
            self.button = ButtonIngredients(title: "Continue", image: nil, tapped: { _ in
                
            })
        }
    }
}
