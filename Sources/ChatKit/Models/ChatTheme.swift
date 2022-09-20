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
    public var meTextColor: UIColor = UIColor(hex: "#343434")
    public var meBackgroundColor: UIColor = UIColor(hex: "#CECECE")
    
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
        
        return theme
    }
    
    public static var bigText: ChatTheme {
        var theme = ChatTheme()
        theme.bubbleFont = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        theme.buttonFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        return theme
    }
    
    
}
