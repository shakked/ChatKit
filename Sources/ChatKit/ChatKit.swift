//
//  ChatKit.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import UIKit
import GitMart

public class ChatKit: GitMartLibrary {
    public static let id = "632b6c551015bcf8ac4843d9"
    public static let name = "ChatKit"
    public static let shared: ChatKit = ChatKit()
    
    private var chatSequences: [ChatSequence] = []
    private var theme: ChatTheme = .lightMode
    
    private var json: [String: Any]? {
        return GitMart.shared.json(for: ChatKit.self)
    }
    
    public static func start() {
        NotificationCenter.default.addObserver(shared, selector: #selector(shared.receivedNotification(_:)), name: GitMart.triggerNotification, object: nil)
    }
    
    func registerChatSequence(sequence: ChatSequence) {
        self.chatSequences.append(sequence)
    }
    
    func registerChatTheme(theme: ChatTheme) {
        self.theme = theme
    }
    
    @objc func receivedNotification(_ notification: Notification) {
        if let eventName = notification.object as? String {
            print("ChatKit received trigger \(eventName)")
            if let eventBlock = (json?["triggers"] as? [String: Any])?[eventName] as? [String: Any] {
                let chat = eventBlock["chat"] as? String ?? ""
                let timesToShow = eventBlock["timesToShow"] as? Int ?? 0
                let chatSequence = chatSequences.first(where: { $0.id == chat })!
                let chatViewController = ChatViewController(chatSequence: chatSequence, theme: theme)
                UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
            } else {
                print("No event found")
            }
        }
    }
    
    public func appDidBecomeActive() {
            
    }
}

struct ChatKitEvent: Decodable {
    let chat: String
    let timesToShow: Int
}

extension UIApplication {
    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = nil
        if #available(iOS 13, *) {
            for scene in connectedScenes {
                if let windowScene = scene as? UIWindowScene {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            topViewController = window.rootViewController
                        }
                    }
                }
            }
        } else {
            topViewController = keyWindow?.rootViewController
        }
        while true {
            if let presented = topViewController?.presentedViewController {
                topViewController = presented
            } else if let navController = topViewController as? UINavigationController {
                topViewController = navController.topViewController
            } else if let tabBarController = topViewController as? UITabBarController {
                topViewController = tabBarController.selectedViewController
            } else {
                // Handle any other third party container in `else if` if required
                break
            }
        }
        return topViewController
    }
}
