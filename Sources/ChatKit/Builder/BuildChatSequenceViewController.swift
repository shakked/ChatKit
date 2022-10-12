//
//  BuildChatSequenceViewController.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

public class BuildChatSequenceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate {

    public var chats: [Chat]
    
    public var indexOfSelectedChat: IndexPath?
    
    public init(chats: [Chat]) {
        self.chats = chats
        super.init(nibName: "BuildChatSequenceViewController", bundle: Bundle.module)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var backButtonPressed: ((BuildChatSequenceViewController) -> ())?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(UINib(nibName: "BuildChatCell", bundle: Bundle.module), forCellReuseIdentifier: BuildChatCell.reuseIdentifier)
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.backButtonPressed?(self)
        }
    }
    
    @IBAction func addChatButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Choose a Message Type", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Message", style: .default) { _ in
            let form = Form(items: [
                LabelFormItem(text: "Messages", font: UIFont.systemFont(ofSize: 32.0, weight: .bold), textColor: UIColor.black.withAlphaComponent(0.72)),
                LabelFormItem(text: "Messages are automated messages that for the user will appear as if they are coming from you.", font: UIFont.systemFont(ofSize: 18.0, weight: .regular), textColor: UIColor.black.withAlphaComponent(0.48)),
                TextInputFormItem(title: "Message", placeholder: "Enter your message here...", regex: nil, minLength: 1, multiLine: true),
            ])
            let formViewController = FormViewController(form: form)
            let navigationViewController = UINavigationController(rootViewController: formViewController)
            formViewController.navigationItem.title = "Add Message"
            self.present(navigationViewController, animated: true)

            formViewController.isValid = { form in
                guard let textInputFormItem = form.items[2] as? TextInputFormItem, let message = textInputFormItem.value, message.count > 0 else {
                    return (false, "Please enter at least 1 character")
                }
                return (true, nil as String?)
            }
            
            formViewController.finished = { form in
                if let textInputFormItem = form.items.first as? TextInputFormItem, let message = textInputFormItem.value {
                    formViewController.dismiss(animated: true) {
                        let newMessage = ChatMessage(message)
                        self.chats.append(newMessage)
                        self.tableView.insertRows(at: [IndexPath(row: self.chats.count - 1, section: 0)], with: .automatic)
                    }
                }
            }
        })
        actionSheet.addAction(UIAlertAction(title: "Random Message", style: .default) { _ in
            let form = Form(items: [
                LabelFormItem(text: "Random Messages", font: UIFont.systemFont(ofSize: 32.0, weight: .bold), textColor: UIColor.black.withAlphaComponent(0.72)),
                LabelFormItem(text: "Random Messages are like normal messages, except you can provide a bunch of different options and the system will randomly choose one each time this chat is excuted.", font: UIFont.systemFont(ofSize: 18.0, weight: .regular), textColor: UIColor.black.withAlphaComponent(0.48)),
                VariableTextOptionsFormItem(addOptionTitle: "Add Message Options", placeholder: "Enter your message here...", maxNumberOfValues: 10),
            ])
            let formViewController = FormViewController(form: form)
            let navigationViewController = UINavigationController(rootViewController: formViewController)
            formViewController.navigationItem.title = "Add Random Message"
            self.present(navigationViewController, animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Conditional", style: .default) { _ in
            let form = Form(items: [
                LabelFormItem(text: "Conditionals", font: UIFont.systemFont(ofSize: 32.0, weight: .bold), textColor: UIColor.black.withAlphaComponent(0.72)),
                LabelFormItem(text: "Conditionals let you provide different options that appear as buttons, where each button leads to a different flow of child chats.", font: UIFont.systemFont(ofSize: 18.0, weight: .regular), textColor: UIColor.black.withAlphaComponent(0.48)),
                VariableTextOptionsFormItem(addOptionTitle: "Add Options", placeholder: "...text here", maxNumberOfValues: 10),
            ])
            let formViewController = FormViewController(form: form)
            let navigationViewController = UINavigationController(rootViewController: formViewController)
            formViewController.navigationItem.title = "Add Conditional Message"
            self.present(navigationViewController, animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Text Input", style: .default) { _ in
            let form = Form(items: [
                LabelFormItem(text: "Text Input", font: UIFont.systemFont(ofSize: 32.0, weight: .bold), textColor: UIColor.black.withAlphaComponent(0.72)),
                LabelFormItem(text: "Text Inputs enable you to ask the user open-ended questions, where they write an answer that conforms to your requirements.", font: UIFont.systemFont(ofSize: 18.0, weight: .regular), textColor: UIColor.black.withAlphaComponent(0.48)),
                TextInputFormItem(title: "Question", placeholder: "Enter your question here...", regex: nil, minLength: 1, multiLine: true),
                TextInputFormItem(title: "Placeholder", placeholder: "The placeholder text for the user...", regex: nil, minLength: 1, multiLine: false),
                SelectFormItem(title: "Keyboard Type", items: UIKeyboardType.all.map({ $0.rawValueString }), value: nil),
                SelectFormItem(title: "Keyboard Action Button", items: UIReturnKeyType.all.map({ $0.rawValueString }), value: nil),
                SelectFormItem(title: "Content Type", items: UITextContentType.all.map({ $0.rawValue }), value: nil),
            ])
            let formViewController = FormViewController(form: form)
            let navigationViewController = UINavigationController(rootViewController: formViewController)
            formViewController.navigationItem.title = "Add Conditional Message"
            self.present(navigationViewController, animated: true)
        })
        actionSheet.addAction(UIAlertAction(title: "Instruction", style: .default) { _ in
            
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(actionSheet, animated: true)
    }
    
    @IBAction func previewChatButtonPressed(_ sender: Any) {
        let sequence = ChatSequence(id: UUID().uuidString, chats: chats)
        let chatVC = ChatViewController(chatSequence: sequence, theme: .bigText)
        self.present(chatVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BuildChatCell = tableView.dequeueReusableCell(withIdentifier: BuildChatCell.reuseIdentifier, for: indexPath) as! BuildChatCell
        let chat: Chat = chats[indexPath.row]
        switch chat.type {
        case .chatMessage:
            if let chat = chat as? ChatMessage {
                cell.titleLabel.text = "Message"
                cell.descriptionLabel.text = chat.message
                cell.accessoryType = .none
            }
        case .chatUserMessage:
            if let chat = chat as? ChatUserMessage {
                cell.titleLabel.text = "User Message"
                cell.descriptionLabel.text = chat.message
                cell.accessoryType = .none
            }
        case .chatRandomMessage:
            if let chat = chat as? ChatRandomMessage {
                cell.titleLabel.text = "Random Message"
                var str = ""
                chat.messages.forEach { message in
                    str.append("- \(message)\n")
                }
                cell.descriptionLabel.text = str
                cell.accessoryType = .none
            }
        case .chatMessageConditional:
            if let chat = chat as? ChatMessageConditional {
                cell.titleLabel.text = "Conditional"
                var str = "\(chat.message)\n\n"
                for i in 0..<chat.options.count {
                    let option = chat.options[i]
                    str.append("(Option \(i + 1)) - \(option.option)\n")
                }
                cell.descriptionLabel.text = str
                cell.accessoryType = .disclosureIndicator
            }
        case .chatTextInput:
            if let chat = chat as? ChatTextInput {
                cell.titleLabel.text = "Text Input"
                
                var msg = "\"\(chat.message)\"\n\n- placeholder: \(chat.placeholder)"
                if let regex = chat.validator?.regex {
                    msg.append("\n- regex: \(regex)")
                }
                msg.append("\n- keyboardType: \(chat.keyboardType.rawValueString)")
                msg.append("\n- returnKey: \(chat.returnKey.rawValueString)")
                if let contentType = chat.contentType {
                    msg.append("\n- contentType: \(contentType.rawValue)")
                }
                cell.descriptionLabel.text = msg
                cell.accessoryType = .none
            }
        case .chatInstruction:
            if let chat = chat as? ChatInstruction {
                var msg: String = ""
                cell.titleLabel.text = "ChatInstruction"
                switch chat.action {
                case .purchaseProduct(let productID):
                    msg = "Purchase Product \(productID)"
                case .restorePurchases:
                    msg = "Restore Purchases"
                case .openURL(let url, let withSafari):
                    msg = "Open URL \(url.absoluteURL) - in SafariViewController \(withSafari)"
                case .requestRating:
                    msg = "Request Rating"
                case .requestWrittenReview:
                    msg = "Request Written Review"
                case .contactSupport:
                    msg = "Contact Support"
                case .other(let str):
                    msg = "Other - \(str)"
                case .dismiss:
                    msg = "Dismiss"
                case .showCancelButton:
                    msg = "Show Cancel Button"
                case .delay(let duration):
                    msg = "Delay \(duration)"
                case .rainingEmojis(let emoji):
                    msg = "Raining Emojis \(emoji)"
                case .loopStart(let id):
                    msg = "Loop Start \(id)"
                case .loopEnd(let id):
                    msg = "Loop End \(id)"
                }
                cell.titleLabel.text = msg
                cell.descriptionLabel.text = ""
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = chats[indexPath.row]
        return [ dragItem ]
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let mover = chats.remove(at: sourceIndexPath.row)
        chats.insert(mover, at: destinationIndexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat: Chat = chats[indexPath.row]
        if let chat = chat as? ChatMessageConditional {
            self.indexOfSelectedChat = indexPath
            let alert = UIAlertController(title: "Choose an Option", message: nil, preferredStyle: .actionSheet)
            let actions = (0..<chat.options.count).forEach({ index in
                let option = chat.options[index]
                alert.addAction(UIAlertAction(title: option.option, style: .default) { _ in
                    let vc = BuildChatSequenceViewController(chats: option.chats)
                    vc.navigationItem.title = option.option
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    vc.backButtonPressed = { controller in
                        let previousOption = chat.options[index]
                        var updatedOptions = chat.options
                        updatedOptions[index] = ChatOption(previousOption.option, sfSymbolName: previousOption.sfSymbolName, chats: controller.chats)
                        let updatedConditional = ChatMessageConditional(message: chat.message, options: updatedOptions)
                        self.chats[indexPath.row] = updatedConditional
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                })
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
}
