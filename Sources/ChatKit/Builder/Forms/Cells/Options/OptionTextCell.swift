//
//  OptionTextCell.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class OptionTextCell: UITableViewCell, ReusableView {
    
    var delete: (() -> ())?
    
    lazy var trashButton: PowerButton = {
        let button = PowerButton()
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20.0, weight: .bold))
        let image = UIImage(systemName: "minus.circle.fill", withConfiguration: configuration)!
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Placeholder"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
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
        contentView.addSubview(trashButton)
        contentView.addSubview(textField)
        
        selectionStyle = .none
        
        trashButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            trashButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16.0),
            trashButton.heightAnchor.constraint(equalToConstant: 40.0),
            trashButton.widthAnchor.constraint(equalToConstant: 40.0),
            trashButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16.0),
            textField.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40.0),
            textField.leadingAnchor.constraint(equalTo: self.trashButton.trailingAnchor, constant: 16.0),
        ])
    }
    
    @objc func deleteButtonPressed() {
        self.delete?()
    }
}
