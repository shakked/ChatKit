//
//  File.swift
//  
//
//  Created by Zachary Shakked on 9/15/22.
//

import Foundation

extension String {
    func estimatedReadingTime() -> TimeInterval {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = self.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        return 0.5 + Double(words.count) * 0.15
    }
}
