//
//  Chat.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public protocol Chat {
    var message: String { get }
    var type: String { get }
}

public extension Chat {
    var type: String {
        return String(describing: Self.self)
    }
}

//public protocol ChatAction {
//    func execute()
//}
//
//public struct ChatActionOpenURL {
//    let url: URL
//}
//
//public struct ChatActionRequestReview {
//
//}
//
//public struct ChatActionOpenAppStoreWriteReviewPage {
//
//}
//
//public struct ChatActionPurchaseIAP {
//
//}
//
//public struct ChatActionShowSuperwallPaywall {
//
//}
//
//public struct ChatActionOpenDeepLink {
//
//}
//
//public struct ChatActionTakeInput {
//
//}
//
//public enum ChatAction2 {
//    case openURL(URL)
//    case requestReview
//    case openAppStoreWriteReviewPage
//    case purchaseIAP(String)
//    case openDeepLink(URL)
//    case restorePurchases
//    case
//}

//protocol ChatKitDelegate {
//
//    func handleChatAction(_ chatAction: ChatAction2, chat: Chat, viewController: ChatViewController) {
//
//        switch chatAction {
//        case .openURL(let uRL):
//
//        case .requestReview:
//            <#code#>
//        case .openAppStoreWriteReviewPage:
//            <#code#>
//        case .purchaseIAP(let string):
//            <#code#>
//        case .openDeepLink(let uRL):
//            <#code#>
//        case .restorePurchases:
//            <#code#>
//        }
//
//
//    }
//}

/**
 
 func handleChatAction(chat: Chat, action: ChatAction) {
 
 
 */

