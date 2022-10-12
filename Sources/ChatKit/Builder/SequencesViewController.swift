//
//  SequencesViewController.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

class SequencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var chatSequences: [ChatSequence] = []
    @IBOutlet weak var tableView: UITableView!
    
    init(chatSequences: [ChatSequence]) {
        self.chatSequences = chatSequences
        super.init(nibName: "SequencesViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCell(type: SequenceCell.self)
        tableView.register(UINib(nibName: "SequenceCell", bundle: Bundle.module), forCellReuseIdentifier: SequenceCell.reuseIdentifier)

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func addButtonPressed() {
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatSequences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SequenceCell = tableView.dequeueReusableCell(withIdentifier: SequenceCell.reuseIdentifier, for: indexPath) as! SequenceCell
        let chatSequence = chatSequences[indexPath.row]
        cell.titleLabel.text = chatSequence.id
        cell.subtitleLabel.text = "\(chatSequence.chats.count) chats"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatSequence = chatSequences[indexPath.row]
        let builderViewController = BuildChatSequenceViewController(chats: chatSequence.chats)
        builderViewController.navigationItem.title = chatSequence.id
        navigationController?.pushViewController(builderViewController, animated: true)
    }
    
    
    
}
