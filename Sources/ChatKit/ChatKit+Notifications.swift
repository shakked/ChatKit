//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/29/22.
//

import UIKit
import NotificationCenter

extension ChatKit: UNUserNotificationCenterDelegate {
    
    public func requestNotificationPermissionsIfNeeded() {
        let key = "kDidRequestNotificationsPermissions"
        let didRequest = UserDefaults.standard.bool(forKey: key)
        if !didRequest {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                UserDefaults.standard.set(true, forKey: key)
            }
        }
    }
    
    public func scheduleNotification(fromUserName: String, chatSequence: ChatSequence, fireDate: Date) {
        let id = "\(chatSequence.id)-\(fireDate.timeIntervalSince1970)"
        let dateComponents = Calendar.current.dateComponents([.calendar, .timeZone,
                                                              .year, .month, .day,
                                                              .hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "id": chatSequence.id,
            "fireDate": fireDate,
        ]
        content.title = "New Message from \(fromUserName)"
        content.body = (chatSequence.chats.first as? ChatMessage)?.message ?? (chatSequence.chats.first as? ChatRandomMessage)?.message ?? ""
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                // Handle any errors.
            } else {
                
            }
        }
        
        let record = PendingChatSequenceRecord(chatID: chatSequence.id, fireDate: fireDate)
        PendingChatSequencesStore.shared.addPendingChatRecord(record)
    }
    
    // MARK: - UNUserNotificationCenterDelegate

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard !PendingChatSequencesStore.shared.presentedLaunchChat else { return }
        PendingChatSequencesStore.shared.presentedLaunchChat = true
        
        // The app is opened from notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let id = response.notification.request.content.userInfo["id"] as? String,
                let chatSequence = ChatKit.shared.chatSequence(for: id),
                let fireDate = response.notification.request.content.userInfo["fireDate"] as? Date {
                
                let chatViewController = ChatViewController(chatSequence: chatSequence, theme: ChatKit.shared.theme)
                UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
                
                let record = PendingChatSequenceRecord(chatID: id, fireDate: fireDate)
                PendingChatSequencesStore.shared.markPendingChatAsFired(record)
            }
        }
        completionHandler()
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard !PendingChatSequencesStore.shared.presentedLaunchChat else { return }
        PendingChatSequencesStore.shared.presentedLaunchChat = true
        
        // The app is open and receives notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let id = notification.request.content.userInfo["id"] as? String,
               let chatSequence = ChatKit.shared.chatSequence(for: id),
               let fireDate = notification.request.content.userInfo["fireDate"] as? Date {
                
                let chatViewController = ChatViewController(chatSequence: chatSequence, theme: ChatKit.shared.theme)
                UIApplication.shared.topViewController()?.present(chatViewController, animated: true)
                
                let record = PendingChatSequenceRecord(chatID: id, fireDate: fireDate)
                PendingChatSequencesStore.shared.markPendingChatAsFired(record)
            }
        }
        completionHandler([])
    }
}
