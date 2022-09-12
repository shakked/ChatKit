//
//  WriteViewController.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public class WriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var messages: [String] = [] {
        didSet {
            let count = messages.count
            tableView.insertRows(at: [IndexPath(row: count - 1, section: 0)], with: .left)
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
    
    public init() {
        super.init(nibName: "WriteViewController", bundle: Bundle.module)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ChatCell", bundle: Bundle.module)
        tableView.register(nib, forCellReuseIdentifier: ChatCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        messages.append("Hey Zach, I wanted to reach out and check out how the app has been going for you these past few days! This is going to be a big ask, but I'd really appreciate if you could write us a review real quick.")
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
