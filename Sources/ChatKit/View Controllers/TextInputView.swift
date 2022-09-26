//
//  TextInputView.swift
//  
//
//  Created by Zachary Shakked on 9/26/22.
//

import UIKit

class TextInputView: UIView, UITextFieldDelegate {
    
    let chatTextInput: ChatTextInput
    let theme: ChatTheme
    
    init(chatTextInput: ChatTextInput, theme: ChatTheme) {
        self.chatTextInput = chatTextInput
        self.theme = theme
        
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var finishedWriting: ((String) -> ())? = nil
    var validator: ChatTextValidator {
        return chatTextInput.validator
    }
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = theme.textInputFont
        textField.textColor = theme.textInputTextColor
        textField.backgroundColor = .clear
        textField.clipsToBounds = true
       
        return textField
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = theme.textInputErrorTextColor
        label.font = theme.textInputErrorFont
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textFieldOutlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = theme.textInputBorderValidColor.cgColor
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = theme.textInputCornerRadius
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 1.375 * theme.textInputFont.pointSize, weight: .medium))
        let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: config)
        button.setTitle("", for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = theme.textInputSendButtonValidColor
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldOutlineView)
        self.addSubview(errorLabel)
        textFieldOutlineView.addSubview(textField)
        textFieldOutlineView.addSubview(sendButton)
        textField.delegate = self
        textField.tintColor = theme.textInputCursorColor
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.keyboardType = chatTextInput.keyboardType
        textField.returnKeyType = chatTextInput.returnKey
        textField.attributedPlaceholder = NSAttributedString(string: chatTextInput.placeholder, attributes: [
            NSAttributedString.Key.font: theme.textInputPlaceholderFont,
            NSAttributedString.Key.foregroundColor: theme.textInputPlaceholderTextColor
        ])
        textField.textContentType = chatTextInput.contentType
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: textFieldOutlineView.topAnchor, constant: -8.0),
            errorLabel.topAnchor.constraint(equalTo: topAnchor),
            errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 16.0),
            
            textFieldOutlineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            textFieldOutlineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            textFieldOutlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            textFieldOutlineView.heightAnchor.constraint(equalToConstant: 2.75 * theme.textInputFont.pointSize)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: textFieldOutlineView.leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: 8.0),
            textField.topAnchor.constraint(equalTo: textFieldOutlineView.topAnchor, constant: 8.0),
            textField.bottomAnchor.constraint(equalTo: textFieldOutlineView.bottomAnchor, constant: -8.0),
            
            sendButton.topAnchor.constraint(equalTo: textFieldOutlineView.topAnchor, constant: -4.0),
            sendButton.trailingAnchor.constraint(equalTo: textFieldOutlineView.trailingAnchor, constant: -8.0),
            sendButton.bottomAnchor.constraint(equalTo: textFieldOutlineView.bottomAnchor, constant: 4.0),
        ])
        
        backgroundColor = .clear
    }
    
    @objc func sendButtonPressed() {
        guard validateText() else { return }
        
        let text = textField.text ?? ""
        finishedWriting?(text)
        textField.endEditing(true)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    // MARK: - UITextViewDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if validateText() {
            textField.endEditing(true)
            self.sendButtonPressed()
            return true
        }
            
        return false
    }
    
    @objc func textChanged() {
        validateText()
    }
    
    @discardableResult
    func validateText() -> Bool {
        let text = textField.text ?? ""
        
        guard validator.validate(text: text) else {
            errorLabel.text = validator.errorMessage
            textFieldOutlineView.layer.borderColor = theme.textInputBorderInvalidColor.cgColor
            sendButton.tintColor = theme.textInputSendButtonInvalidColor
            return false
        }
        
        errorLabel.text = nil
        textFieldOutlineView.layer.borderColor = theme.textInputBorderValidColor.cgColor
        sendButton.tintColor = theme.textInputSendButtonValidColor
        return true
    }
}
