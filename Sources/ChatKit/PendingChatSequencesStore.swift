//
//  PendingChatSequencesStore.swift
//  
//
//  Created by Zachary Shakked on 9/29/22.
//

import Foundation

class PendingChatSequencesStore {
    
    private let storeKey = "kPendingChatSequenceStoreKey"
    static let shared: PendingChatSequencesStore = PendingChatSequencesStore()
    
    var presentedLaunchChat: Bool = false
    private var pendingChatSequenceRecords: [PendingChatSequenceRecord] {
        get {
            if let data = UserDefaults.standard.data(forKey: storeKey) {
                let decoder = JSONDecoder()
                if let pendingChatSequenceRecords = try? decoder.decode([PendingChatSequenceRecord].self, from: data) {
                    print("GET PendingChatSequenceRecords: \(pendingChatSequenceRecords)")
                    return pendingChatSequenceRecords
                }
            }
            return []
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: storeKey)
                print("SET PendingChatSequenceRecords: \(pendingChatSequenceRecords)")
            }
        }
    }
    
    func nextValidSequenceRecord() -> PendingChatSequenceRecord? {
        let now = Date()
        let readyToFire = pendingChatSequenceRecords.filter({ $0.fireDate.timeIntervalSince1970 < now.timeIntervalSince1970 })
        if let latest = readyToFire.sorted(by: { $0.fireDate.timeIntervalSince1970 < $1.fireDate.timeIntervalSince1970 }).first {
            return latest
        }
        return nil
    }
    
    func addPendingChatRecord(_ pendingChatRecord: PendingChatSequenceRecord) {
        self.pendingChatSequenceRecords.append(pendingChatRecord)
    }
    
    func markPendingChatAsFired(_ pendingChatSequenceRecord: PendingChatSequenceRecord) {
        pendingChatSequenceRecords = pendingChatSequenceRecords.filter({ !($0.fireDate == pendingChatSequenceRecord.fireDate && $0.chatID == pendingChatSequenceRecord.chatID) })
    }
}
