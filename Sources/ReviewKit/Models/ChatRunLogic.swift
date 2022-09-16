//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/16/22.
//

import UIKit

public struct ChatRunLogic: Chat {
    public let message: String = ""
    public let block: ((UIViewController) -> ())
    
    public init(block: @escaping ((UIViewController) -> ())) {
        self.block = block
    }
}
