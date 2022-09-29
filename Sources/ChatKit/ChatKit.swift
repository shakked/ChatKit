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
        NotificationCenter.default.addObserver(ChatKit.shared, selector: #selector(ChatKit.shared.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(ChatKit.shared, selector: #selector(ChatKit.shared.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Note - if the user overwrites this, we won't receive local notification things
        UNUserNotificationCenter.current().delegate = ChatKit.shared
    }
    
    @objc func applicationDidBecomeActive() {
        guard !PendingChatSequencesStore.shared.presentedLaunchChat else { return }
        PendingChatSequencesStore.shared.presentedLaunchChat = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let pendingChat = PendingChatSequencesStore.shared.nextValidSequenceRecord(), let chatSequence = ChatKit.shared.chatSequence(for: pendingChat.chatID) {
                let chatViewController = ChatViewController(chatSequence: chatSequence, theme: self.theme)
                UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
            }
        }
    }
    
    @objc func applicationDidEnterBackground() {
        // App goes into background and opens back up, it will
        PendingChatSequencesStore.shared.presentedLaunchChat = false
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
                    let currentViewCount = ChatKit.shared.viewCount(for: chatSequence.id, event: eventName)
                    if currentViewCount < timesToShow {
                        ChatKit.shared.registerViewCount(for: chatID, event: eventName)
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
        return chatSequences.filter({ $0.id == id }).first?.copy()
    }
    
    func viewCount(for chatSequenceID: String, event: String) -> Int {
        let key = "kViewCount-\(chatSequenceID)-\(event)"
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func registerViewCount(for chatSequenceID: String, event: String) {
        let key = "kViewCount-\(chatSequenceID)-\(event)"
        let currentViewCount = viewCount(for: chatSequenceID, event: event)
        UserDefaults.standard.set(currentViewCount + 1, forKey: key)
    }
       
}

