//
//  TextViewInputCell.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class TextViewInputCell: UITableViewCell, ReusableView, UITextViewDelegate {
    
    var textChanged: ((String) -> ())? = nil
        
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textColor = .black
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.10)
        textView.layer.cornerRadius = 4.0
        textView.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        textView.textColor = .black
        textView.isScrollEnabled = false
        return textView
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        selectionStyle = .none
        textView.delegate = self
        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        bar.items = [reset]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
        ])
    }
    
    @objc func done() {
        self.textView.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        self.textChanged?(textView.text)
        self.textView.textViewDidChange(textView)
    }
 
}
