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
