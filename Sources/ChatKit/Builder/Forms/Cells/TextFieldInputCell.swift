//
//  TextInputCell.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class TextFieldInputCell: UITableViewCell, ReusableView {
    
    var textChanged: ((String) -> ())?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Placeholder"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.backgroundColor = .white
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(textField)
        selectionStyle = .none
        
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            titleLabel.trailingAnchor.constraint(equalTo: textField.leadingAnchor),
            titleLabel.widthAnchor.constraint(equalTo: textField.widthAnchor),
            
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40.0),
        ])
    }
    
    @objc func textFieldChanged() {
        self.textChanged?(textField.text ?? "")
    }
}
