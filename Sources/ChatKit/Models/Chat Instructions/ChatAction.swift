//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import UIKit
import GitMart

public enum ChatAction {
    case purchaseProduct(String)
    case restorePurchases
    case openURL(URL, Bool)
    case requestRating
    case requestWrittenReview
    // case requestPermission(GitMartPermission)
    case contactSupport
    case other(String)
    case dismiss
    case showCancelButton
    case delay(TimeInterval)
    case rainingEmojis(String)
    case loopStart(String)
    case loopEnd(String)
    
    var loopID: String? {
        switch self {
        case .loopStart(let id):
            return id
        case .loopEnd(let id):
            return id
        default:
            return nil
        }
    }
    
//    init(json: [String: Any]) {
//
//    }
}
