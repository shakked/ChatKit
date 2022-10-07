//
//  JSON.swift
//  
//
//  Created by Zachary Shakked on 10/4/22.
//

import Foundation

protocol JSONObject {
    init(json: JSON)
    var jsonDictionary: [String: Any] { get }
}

struct JSON {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    var stringValue: String {
        return value as? String ?? ""
    }
    var string: String? {
        return value as? String
    }
    
    var intValue: Int {
        return value as? Int ?? 0
    }
    var int: Int? {
        return value as? Int
    }
    
    var doubleValue: Double {
        return value as? Double ?? 0.0
    }
    
    var double: Double? {
        return value as? Double
    }
    
    var array: [JSON]? {
        if let array = value as? [Any] {
            return array.map(JSON.init)
        }
        return nil
    }
    
    var arrayValue: [JSON] {
        if let array = value as? [Any] {
            return array.map(JSON.init)
        }
        return []
    }
    
    var dictionary: [String: JSON]? {
        if let dictionary = value as? [String: Any] {
            var updatedDictionary: [String: JSON] = [:]
            dictionary.keys.forEach { key in
                if let value = dictionary[key] {
                    updatedDictionary[key] = JSON(value)
                }
            }
            return updatedDictionary
        }
        return nil
    }
    
    var dictionaryValue: [String: JSON] {
        if let dictionary = value as? [String: Any] {
            var updatedDictionary: [String: JSON] = [:]
            dictionary.keys.forEach { key in
                if let value = dictionary[key] {
                    updatedDictionary[key] = JSON(value)
                }
            }
            return updatedDictionary
        }
        return [:]
    }
    
    var boolValue: Bool {
        return value as? Bool ?? false
    }
    
    var bool: Bool? {
        return value as? Bool
    }
    
    var date: Date? {
        if let dateString = string {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    var dateValue: Date {
        return date ?? Date()
    }
    
    subscript(_ key: String) -> JSON {
        if let value = value as? [String: Any], let keyValue = value[key] {
            return JSON(keyValue)
        }
        return JSON([:])
    }
}
