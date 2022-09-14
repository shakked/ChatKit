//
//  WriteViewController.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public struct ChatTheme {
    public let profilePicture: UIImage
    public let name: String
    public let title: String
    public let location: String
    public let primaryColor: UIColor
    public let buttonColor: UIColor
    public let buttonTextColor: UIColor
    
    public init(profilePicture: UIImage, name: String, title: String, location: String, primaryColor: UIColor, buttonColor: UIColor, buttonTextColor: UIColor) {
        self.profilePicture = profilePicture
        self.name = name
        self.title = title
        self.location = location
        self.primaryColor = primaryColor
        self.buttonColor = buttonColor
        self.buttonTextColor = buttonTextColor
    }
}

public class WriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    let chatSequence: ChatSequence
    enum ChatType {
        case user, app
    }
    
    private var messages: [(String, ChatType)] = [] {
        didSet {
            let count = messages.count
            let message = messages[count - 1]
            tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: message.1 == .app ? .left : .right)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.tableView.contentSize.height > self.tableView.frame.height {
                    self.tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusLabel: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
    }
    
    public init(chatSequence: ChatSequence) {
        self.chatSequence = chatSequence
        super.init(nibName: "WriteViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ChatCell", bundle: Bundle.module), forCellReuseIdentifier: ChatCell.reuseIdentifier)
        tableView.register(UINib(nibName: "UserChatCell", bundle: Bundle.module), forCellReuseIdentifier: UserChatCell.reuseIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        chatSequence.addMessage = { [unowned self] chat in
            self.messages.append((chat, .app))
        }
        chatSequence.addUserMessage = { [unowned self] chat in
            self.messages.append((chat, .user))
        }
        chatSequence.showButtons = { conditionalChat in
            let options = conditionalChat.options
            self.currentConditionalChat = conditionalChat
            UIView.animate(withDuration: 0.5) {
                options.forEach { [unowned self] text in
                    let button = PowerButton()
                    button.backgroundColor = .blue
                    button.setTitle(text, for: .normal)
                    button.setTitleColor(.white, for: .normal)
                    button.cornerRadius = 8.0
                    button.clipsToBounds = true
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
                    button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                    self.stackView.addArrangedSubview(button)
                }
            }
        }
        
        chatSequence.hideButtons = {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.chatSequence.start()
        }
    }
    
    fileprivate var currentConditionalChat: ChatMessageConditional?
    
    @objc func buttonPressed(_ sender: PowerButton) {
        guard let currentConditionalChat = currentConditionalChat else {
            return
        }
        
        let title = sender.titleLabel?.text ?? ""
        guard let index = self.currentConditionalChat?.options.index(of: title) else { return }
        
        chatSequence.userTappedButton(index: index, buttonText: title, chat: currentConditionalChat)
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.stackView.arrangedSubviews.forEach { view in
                view.isHidden = true
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        switch message.1 {
        case .app:
            let cell: ChatCell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier) as! ChatCell
            cell.messageLabel.text = message.0
            return cell
        case .user:
            let cell: UserChatCell = tableView.dequeueReusableCell(withIdentifier: UserChatCell.reuseIdentifier) as! UserChatCell
            cell.messageLabel.text = message.0
            return cell
        }
    }
    
}
