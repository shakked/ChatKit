//
//  WriteViewController.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public class WriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    let chats: [Chat]

    private var messages: [String] = [] {
        didSet {
            let count = messages.count
            tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: .left)
            
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
    }
    
    public init(chats: [Chat]) {
        self.chats = chats
        super.init(nibName: "WriteViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ChatCell", bundle: Bundle.module)
        tableView.register(nib, forCellReuseIdentifier: ChatCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        for i in (0..<chats.count) {
            let chat = chats[i]
            if i == 0 {
                self.messages.append(chat.message)
            } else {
                let previousReadTime = chats[0...(i - 1)].reduce(0.0, { $0 + $1.estimatedReadTime })
                print("\(chat.estimatedReadTime)s - \(chat.message)")
                DispatchQueue.main.asyncAfter(deadline: .now() + previousReadTime) {
                    self.messages.append(chat.message)
                }
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        // chatMessages.append("Hey Zach, I wanted to reach out and check out how the app has been going for you these past few days! This is going to be a big ask, but I'd really appreciate if you could write us a review real quick.")
        
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.reuseIdentifier) as! ChatCell
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
    
}
