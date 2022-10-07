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
    public var bubbleFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    public var bubbleCornerRadius: CGFloat = 18.0
    
    public var backgroundColor: UIColor = UIColor.white
    public var chatViewCornerRadius: CGFloat = 18.0
    public var chatViewBackgroundColor: UIColor = .white

    public var buttonBackgroundColor: UIColor = UIColor(hex: "#027AFF")
    public var buttonTextColor: UIColor = UIColor.white
    public var buttonFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    public var buttonCornerRadius: CGFloat = 18.0
    
    public var xButtonTintColor: UIColor = UIColor.darkGray
    
    // Text Input
    public var textInputCursorColor: UIColor = UIColor(hex: "#027AFF")
    public var textInputBorderValidColor: UIColor = UIColor(hex: "#d4d4d7")
    public var textInputBorderInvalidColor: UIColor = UIColor(hex: "#E26868")
    public var textInputTextColor: UIColor = UIColor.black
    public var textInputCornerRadius: CGFloat = 20.0
    public var textInputFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    public var textInputErrorFont: UIFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    public var textInputErrorTextColor: UIColor = UIColor(hex: "#E26868")
    public var textInputPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    public var textInputPlaceholderTextColor: UIColor = UIColor.black.withAlphaComponent(0.48)
    public var textInputSendButtonValidColor: UIColor = UIColor(hex: "#027AFF")
    public var textInputSendButtonInvalidColor: UIColor = UIColor(hex: "#d4d4d7")
    
    public init() {
        
    }
    
    /*
     TODO: Finish - note, the tricky parts are fonts and colors with alpha
        init(json: JSON) {
            self.hidesCancelButtonOnStart = json["hidesCancelButtonOnStart"].bool ?? true
            self.meTextColor = json["meTextColor"].color ?? .white
            self.meBackgroundColor = json["meBackgroundColor"].color ?? UIColor(hex: "#949494")
            
            self.meBubbleColor = json["meBubbleColor"].color ?? UIColor(hex: "#027AFF")
            self.meBubbleTextColor = json["meBubbleTextColor"].color ?? .white
            self.appBubbleColor = json["appBubbleColor"].color ?? UIColor(hex: "#d4d4d7")
            self.appBubbleTextColor = json["appBubbleTextColor"].color ?? UIColor(hex: "#000000")
            self.bubbleFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            self.bubbleCornerRadius = json["bubbleCornerRadius"].double ?? 18.0
            
            self.xButtonTintColor = json["xButtonTintColor"].color ?? .darkGray
            self.textInputCursorColor = json["textInputCursorColor"].color ?? UIColor(hex: "#027AFF")
            self.textInputBorderValidColor = json["textInputBorderValidColor"].color ?? UIColor(hex: "#d4d4d7")
            self.textInputBorderInvalidColor = json["textInputBorderInvalidColor"].color ?? UIColor(hex: "#E26868")
            self.textInputTextColor = json["textInputTextColor"].color ?? UIColor.black
            self.textInputCornerRadius = json["textInputCornerRadius"].double ?? 20.0
            self.textInputFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            self.textInputErrorFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            self.textInputErrorTextColor = json["textInputErrorTextColor"].color ?? UIColor(hex: "#E26868")
            self.textInputPlaceholderFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            self.textInputPlaceholderTextColor = json["textInputPlaceholderTextColor"].color ?? UIColor.black.withAlphaComponent(0.48)
            self.textInputSendButtonValidColor = json["textInputSendButtonValidColor"].color ?? UIColor(hex: "#027AFF")
            self.textInputSendButtonInvalidColor = json["textInputSendButtonInvalidColor"].color ?? UIColor(hex: "#d4d4d7")
        }
    */
    
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
