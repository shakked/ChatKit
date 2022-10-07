//
//  WriteViewController.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit
import SafariServices
import GitMart

public class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    let chatSequence: ChatSequence
    let theme: ChatTheme
    
    enum ChatType {
        case user, app
    }
    
    public var analyticEventBlock: ((String) -> ())? = nil
    
    private var messages: [(String, ChatType)] = [] {
        didSet {
            let count = messages.count
            tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: .none)
            self.scrollToBottomOfTableView()
        }
    }
    private var currentButtons: [PowerButton] = []
    private var currentChat: Chat?
    private var textInputView: TextInputView?
    
    static var animatedIndexPaths: Set<IndexPath> = Set<IndexPath>()
    
    @IBOutlet weak var cancelButtonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var stackViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    public init(chatSequence: ChatSequence, theme: ChatTheme) {
        self.chatSequence = chatSequence
        self.theme = theme
        super.init(nibName: "ChatViewController", bundle: Bundle.module)
        ChatViewController.animatedIndexPaths = Set<IndexPath>()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        cancelButtonTopMargin.constant = modalPresentationStyle == .fullScreen ? 0 : 8
        
        if theme.hidesCancelButtonOnStart {
            cancelButton.alpha = 0.0
            cancelButton.isHidden = true
        }
        
        cancelButton.setTitle("", for: .normal)
        tableView.backgroundColor = theme.chatViewBackgroundColor
        tableView.layer.cornerRadius = theme.chatViewCornerRadius
        backgroundView.backgroundColor = theme.backgroundColor
        cancelButton.tintColor = theme.xButtonTintColor
        
        tableView.register(UINib(nibName: "ChatCell", bundle: Bundle.module), forCellReuseIdentifier: ChatCell.reuseIdentifier)
        tableView.register(UINib(nibName: "UserChatCell", bundle: Bundle.module), forCellReuseIdentifier: UserChatCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        setupChatSequenceBlocks()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [unowned self] in
            self.chatSequence.start()
        }
        
        chatSequence.controller = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.chatSequence.stop()
        self.chatSequence.dismissed()
    }
    
    @objc func buttonPressed(_ sender: PowerButton) {
        guard let currentChat = currentChat else {
            return
        }
        
        let title = sender.titleLabel?.text ?? ""
        if let conditionalChat = currentChat as? ChatMessageConditional {
            guard let index = conditionalChat.options.firstIndex(where: { $0.option == title }) else { return }
            chatSequence.userTappedButton(index: index, buttonText: title, chat: conditionalChat, controller: self)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    var animatedCells: Set<String> = Set<String>()
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let previous = indexPath.row - 1 >= 0 ? messages[indexPath.row - 1] : nil
        
        switch message.1 {
        case .app:
            let cell: ChatCell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier) as! ChatCell
            if let prev = previous, prev.1 == message.1 {
                cell.topMarginConstraint.constant = 0
            }
            cell.currentIndexPath = indexPath
            cell.configure(for: theme)
            cell.messageLabel.text = message.0
            return cell
        case .user:
            let cell: UserChatCell = tableView.dequeueReusableCell(withIdentifier: UserChatCell.reuseIdentifier) as! UserChatCell
            if let prev = previous, prev.1 == message.1 {
                cell.topMarginConstraint.constant = 0
            }
            cell.currentIndexPath = indexPath
            cell.configure(for: theme)
            cell.messageLabel.text = message.0
            
            return cell
        }
    }
    
    // MARK: - Config
    
    func setupChatSequenceBlocks() {
        chatSequence.showCancelButton = { [unowned self] in
            self.cancelButton.isHidden = false
            UIView.animate(withDuration: 0.35) {
                self.cancelButton.alpha = 1.0
            }
        }
        chatSequence.dismiss = { [unowned self] in
            self.dismiss(animated: true)
        }
        chatSequence.addMessage = { [unowned self] chat in
            self.messages.append((chat, .app))
        }
        chatSequence.addUserMessage = { [unowned self] chat in
            self.messages.append((chat, .user))
        }
        chatSequence.showButtons = { (chatMessageConditional: ChatMessageConditional) -> () in
            self.currentChat = chatMessageConditional
            let options = chatMessageConditional.options
            let buttons = options.map { [unowned self] (option: ChatOption) -> PowerButton in
                let button = self.powerButton(title: option.option)
                self.stackView.addArrangedSubview(button)
                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 38.0)
                ])
                return button
            }
            self.currentButtons = buttons
            // self.stackViewHeight.isActive = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: [.allowUserInteraction, .curveEaseInOut], animations: { [unowned self] in
                    buttons.forEach({ $0.isHidden = false })
                    self.stackView.layoutIfNeeded()
                }) { _ in
                    self.scrollToBottomOfTableView()
                }
            }
        }
        
        chatSequence.startTyping = {
            // TODO
        }
        
        chatSequence.stopTyping = {
            // TODO
        }
        
        chatSequence.hideButtons = {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                self.springAnimation {
                    self.currentButtons.forEach({ $0.isHidden = true; $0.alpha = 0.0 })
                    self.stackView.layoutIfNeeded()
                } completion: {
                    // self.stackViewHeight.isActive = true
                }
            }
        }
        
        chatSequence.showTextInput = { [unowned self] chatTextInput in
            let textInputView = TextInputView(chatTextInput: chatTextInput, theme: self.theme)
            textInputView.chatTextInput = chatTextInput
            textInputView.alpha = 0.0
            textInputView.isHidden = true
            self.textInputView = textInputView
            self.stackView.addArrangedSubview(textInputView)
            textInputView.textField.becomeFirstResponder()
            textInputView.finishedWriting = { [unowned self] text in
                self.inputText = text
                self.chatTextInput = chatTextInput
                textInputView.endEditing(true)
                self.chatSequence.userEnteredText(text: text, chat: chatTextInput, controller: self)
            }
        }
    }
    
    var inputText: String?
    var chatTextInput: ChatTextInput?
    
    
    private func powerButton(title: String) -> PowerButton {
        let button = PowerButton()
        button.tintColor = theme.buttonTextColor
        button.backgroundColor = theme.buttonBackgroundColor
        button.setTitle(title, for: .normal)
        button.setTitleColor(theme.buttonTextColor, for: .normal)
        button.cornerRadius = 16.0
        button.clipsToBounds = true
        button.titleLabel?.font = theme.buttonFont
        button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }
    
    private func springAnimation(animations: @escaping () -> (), completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.5, options: [.allowUserInteraction, .curveEaseInOut], animations: animations, completion: { _ in
            completion()
        })
    }
    
    
    private func scrollToBottomOfTableView() {
        if self.tableView.contentSize.height > self.tableView.bounds.height, messages.count > 1 {
            self.tableView.scrollToRow(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let textInputView = textInputView else { return }
        
        NSLayoutConstraint.activate([
            textInputView.heightAnchor.constraint(greaterThanOrEqualToConstant: 4.4 * theme.textInputFont.pointSize)
        ])
        
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        stackViewBottomMargin.constant = keyboardHeight

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.45, animations: {
                self.view.layoutIfNeeded()
                textInputView.alpha = 1.0
                textInputView.isHidden = false
                
                // self.stackView.layoutIfNeeded()
                // something about adding the above buttons screws up the UIStackView animations - idk why?
            }, completion: { _ in
                self.scrollToBottomOfTableView()
            })
        }
    }
    
    @objc private func keyboardWillHide() {
        guard let textInputView = textInputView else { return }
        // NOTE: Animation times can get ignored if not done on main queue
        DispatchQueue.main.async {
            self.stackViewBottomMargin.constant = 42
            UIView.animate(withDuration: 0.45, delay: 0.0, animations: {
                textInputView.alpha = 0.0
                textInputView.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.stackView.removeArrangedSubview(textInputView)
                self.scrollToBottomOfTableView()
                self.textInputView = nil
            })
        }
    }
}
