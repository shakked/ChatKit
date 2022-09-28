//
//  ChatTheme.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public struct ChatTheme {

    public var hidesCancelButtonOnStart: Bool = true
    
    public var profilePicture: UIImage = UIImage(named: "Profile Picture", in: Bundle.module, with: nil)!
    public var meTextColor: UIColor = UIColor.white
    public var meBackgroundColor: UIColor = UIColor(hex: "#949494")
    
    // Bubbles
    public var meBubbleColor: UIColor = UIColor(hex: "#027AFF")
    public var meBubbleTextColor: UIColor = UIColor.white
    public var appBubbleColor: UIColor = UIColor(hex: "#d4d4d7")
    public var appBubbleTextColor: UIColor = UIColor(hex: "#000000")
    public var bubbleFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    public var bubbleCornerRadius: CGFloat = 16.0
    
    public var backgroundColor: UIColor = UIColor.white
    public var chatViewCornerRadius: CGFloat = 16.0
    public var chatViewBackgroundColor: UIColor = .white

    public var buttonBackgroundColor: UIColor = UIColor(hex: "#027AFF")
    public var buttonTextColor: UIColor = UIColor.white
    public var buttonFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
    public var buttonCornerRadius: CGFloat = 16.0
    
    public var xButtonTintColor: UIColor = UIColor.darkGray
    
    // Text Input
    public var textInputCursorColor: UIColor = UIColor(hex: "#027AFF")
    public var textInputBorderValidColor: UIColor = UIColor(hex: "#d4d4d7")
    public var textInputBorderInvalidColor: UIColor = UIColor(hex: "#E26868")
    public var textInputTextColor: UIColor = UIColor.black
    public var textInputCornerRadius: CGFloat = 20.0
    public var textInputFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    public var textInputErrorFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    public var textInputErrorTextColor: UIColor = UIColor(hex: "#E26868")
    public var textInputPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    public var textInputPlaceholderTextColor: UIColor = UIColor.black.withAlphaComponent(0.48)
    public var textInputSendButtonValidColor: UIColor = UIColor(hex: "#027AFF")
    public var textInputSendButtonInvalidColor: UIColor = UIColor(hex: "#d4d4d7")
    
    public init() {
        
    }
    
    public static var lightMode: ChatTheme {
        return ChatTheme()
    }
    
    public static var darkMode: ChatTheme {
        var theme = ChatTheme()
        theme.backgroundColor = .black
        theme.chatViewBackgroundColor = UIColor.black
        theme.appBubbleColor = UIColor(hex: "#4D4D4D")
        theme.appBubbleTextColor = UIColor.white
        theme.xButtonTintColor = UIColor.white
        
        theme.textInputTextColor = UIColor.white
        theme.textInputPlaceholderTextColor = UIColor.white.withAlphaComponent(0.48)
        theme.textInputBorderValidColor = UIColor.white.withAlphaComponent(0.48)
        theme.textInputSendButtonValidColor = UIColor(hex: "#CECECE")
        theme.textInputSendButtonInvalidColor = UIColor(hex: "#828488")
        
        return theme
    }
    
    public static var twitter: ChatTheme {
        var theme = ChatTheme()
        theme.backgroundColor = UIColor(hex: "#15202B")
        theme.chatViewBackgroundColor = UIColor(hex: "#15202B")
        theme.appBubbleColor = UIColor(hex: "#3D5566")
        theme.appBubbleTextColor = UIColor.white
        theme.xButtonTintColor = UIColor.white
        
        theme.buttonBackgroundColor = UIColor.white
        theme.buttonTextColor = UIColor(hex: "#3D5566")
        
        theme.textInputTextColor = UIColor.white
        theme.textInputPlaceholderTextColor = UIColor.white.withAlphaComponent(0.48)
        theme.textInputBorderValidColor = UIColor.white.withAlphaComponent(0.48)
        theme.textInputSendButtonValidColor = UIColor.white
        theme.textInputSendButtonInvalidColor = UIColor(hex: "#828488")
        
        return theme
    }
    
    public static var bigText: ChatTheme {
        var theme = ChatTheme()
        theme.bubbleFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        theme.buttonFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        theme.textInputFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        theme.textInputErrorFont = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        theme.textInputPlaceholderFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        
        return theme
    }
    
    
}
