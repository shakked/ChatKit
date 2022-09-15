//
//  File 2.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import UIKit

public protocol Chat {
    var message: String { get }
    var numberOfWords: Int { get }
    var estimatedReadTime: TimeInterval { get }
}

public extension Chat {
    var numberOfWords: Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = message.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }
    
    var estimatedReadTime: TimeInterval {
        return 1 + Double(numberOfWords) * 0.2
    }
}
