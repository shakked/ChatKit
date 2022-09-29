//
//  ChatKit.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import UIKit
import GitMart
import NotificationCenter

public class ChatKit: NSObject, GitMartLibrary {
    public static let id = "632b6c551015bcf8ac4843d9"
    public static let name = "ChatKit"
    public static let shared: ChatKit = ChatKit()
    public static let version: String = "0.2.0"
    
    private(set) var chatSequences: [ChatSequence] = []
    private(set) var theme: ChatTheme = .lightMode
    
    private var json: [String: Any]? {
        return GitMart.shared.json(for: ChatKit.self)
    }
    
    // Automatically called on GitMart init
    public static func start() {
        NotificationCenter.default.addObserver(ChatKit.shared, selector: #selector(ChatKit.shared.receivedNotification(_:)), name: GitMart.triggerNotification, object: nil)
        
        // Note - if the user overwrites this, we won't receive local notification things
        UNUserNotificationCenter.current().delegate = ChatKit.shared
    }
    
    func registerChatSequence(sequence: ChatSequence) {
        self.chatSequences.append(sequence)
    }
    
    func registerChatTheme(theme: ChatTheme) {
        self.theme = theme
    }
    
    @objc func receivedNotification(_ notification: Notification) {
        if let eventName = notification.object as? String {
            GMLogger.shared.log(.module(ChatKit.self), "Received trigger: \(eventName)")
            if let eventBlock = (json?["triggers"] as? [String: Any])?[eventName] as? [String: Any] {
                let chatID = eventBlock["chatID"] as? String ?? ""
                let timesToShow = eventBlock["timesToShow"] as? Int ?? 0
                if let chatSequence = chatSequence(for: chatID) {
                    let currentViewCount = ChatKit.shared.viewCount(for: chatSequence.id)
                    if currentViewCount < timesToShow {
                        let chatViewController = ChatViewController(chatSequence: chatSequence.copy(), theme: theme)
                        UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
                        GMLogger.shared.log(.module(ChatKit.self), "Presenting chat sequence: \(chatSequence.id) - viewCount: \(currentViewCount) - timesToShow: \(timesToShow)")
                    }
                }
            } else {
                // No JSON trigger instruction
            }
        }
    }
    
    func chatSequence(for id: String) -> ChatSequence? {
        return chatSequences.filter({ $0.id == id }).first
    }
    
    func viewCount(for chatSequenceID: String) -> Int {
        let key = "kViewCount-\(chatSequenceID)"
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func registerViewCount(for chatSequenceID: String) {
        let key = "kViewCount-\(chatSequenceID)"
        let currentViewCount = viewCount(for: chatSequenceID)
        UserDefaults.standard.set(currentViewCount + 1, forKey: key)
    }
}
