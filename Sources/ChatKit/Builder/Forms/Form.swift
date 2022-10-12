//
//  Form.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

protocol FormItem {
    
}

class Form {
    var items: [FormItem]
    
    init(items: [FormItem]) {
        self.items = items
    }
}

class LabelFormItem: FormItem {
    var text: String
    let font: UIFont
    let textColor: UIColor
    
    init(text: String, font: UIFont, textColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}

class TextInputFormItem: FormItem {
    let title: String
    let placeholder: String
    let regex: String?
    let minLength: Int
    let multiLine: Bool
    
    var value: String?
    
    init(title: String, placeholder: String, regex: String?, minLength: Int, multiLine: Bool, value: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.regex = regex
        self.minLength = minLength
        self.multiLine = multiLine
        self.value = value
    }
}

struct SwitchFormItem: FormItem {
    let title: String
    var value: Bool
    
    var cellCount: Int {
        return 1
    }
}

struct OptionsFormItem: FormItem {
    let options: [String]
    var value: String
    
    var cellCount: Int {
        return 1
    }
}

struct ListFormItem: FormItem {
    let title: String
    let placeholder: String
    let maxItemCount: Int
    
    var cellCount: Int {
        return 1
    }
}

struct VariableTextOptionsFormItem: FormItem {
    let addOptionTitle: String
    let placeholder: String
    let maxNumberOfValues: Int
    
    var cellCount: Int {
        return 1
    }
}

struct TextOption: FormItem {
    let title: String
    let placeholder: String
    let hash: String = String(Date().timeIntervalSince1970)
    var value: String
    
    var parent: VariableTextOptionsFormItem?
    
    var cellCount: Int {
        return 1
    }
}

struct SelectFormItem: FormItem {
    let title: String
    let items: [String]
    var value: String?
    
    var cellCount: Int {
        return 1
    }
}
