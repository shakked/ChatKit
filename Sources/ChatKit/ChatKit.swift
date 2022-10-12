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
    public static let bundleID: String = "chat-kit"
    
    private(set) var chatSequences: [ChatSequence] = []
    private(set) var triggers: [Trigger] = []
    private(set) var theme: ChatTheme = .lightMode
    
    private var json: [String: Any]? {
        return GitMart.shared.json(for: ChatKit.self)
    }
    
    // Automatically called on GitMart init
    public static func start() {
        NotificationCenter.default.addObserver(ChatKit.shared, selector: #selector(ChatKit.shared.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(ChatKit.shared, selector: #selector(ChatKit.shared.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Note - if the user overwrites this, we won't receive local notification things
        UNUserNotificationCenter.current().delegate = ChatKit.shared
        
        // Look into this
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [
            
        ])
    }
    
    @objc func applicationDidBecomeActive() {
        guard !PendingChatSequencesStore.shared.presentedLaunchChat else { return }
        PendingChatSequencesStore.shared.presentedLaunchChat = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let pendingChat = PendingChatSequencesStore.shared.nextValidSequenceRecord(), let chatSequence = ChatKit.shared.chatSequence(for: pendingChat.chatID) {
                let chatViewController = ChatViewController(chatSequence: chatSequence, theme: self.theme)
                UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
                PendingChatSequencesStore.shared.markPendingChatAsFired(pendingChat)
            }
        }
    }
    
    public func showBuilder(on controller: UIViewController) {
        let sequencesViewController = SequencesViewController(chatSequences: chatSequences)
        let navigationController = UINavigationController(rootViewController: sequencesViewController)
        navigationController.modalPresentationStyle = .fullScreen
        controller.present(navigationController, animated: true)
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
    
    public static func handleEvent(eventName: String, properties: [String : Any]) {
        guard let trigger = shared.triggers.filter({ $0.event == eventName }).first else { return }
        guard let chatSequence = shared.chatSequence(for: trigger.chatSequenceID) else { return }
        
        let timesToShow = trigger.count
        let currentViewCount = ChatKit.shared.viewCount(for: chatSequence.id, event: eventName)
        if currentViewCount < timesToShow {
            let probability = trigger.probability
            if probability < 1.0 {
                let random = Double.random(in: 0..<1)
                if random > probability {
                    return
                }
            }
            
            ChatKit.shared.registerViewCount(for: chatSequence.id, event: eventName)
            let chatViewController = ChatViewController(chatSequence: chatSequence.copy(), theme: shared.theme)
            UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
            GMLogger.shared.log(.module(ChatKit.self), "Presenting chat sequence: \(chatSequence.id) - viewCount: \(currentViewCount) - timesToShow: \(timesToShow)")
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
    
    // MARK: - JSON
    
    public static func jsonLoaded(dictionary: [String : Any]) {
        let json = JSON(dictionary)
        json["sequences"].arrayValue.forEach({ json in
            let chatSequence = ChatSequence(json: json)
            self.shared.registerChatSequence(sequence: chatSequence)
        })
        
        self.shared.triggers = json["triggers"].arrayValue.map(Trigger.init)
    }
}

