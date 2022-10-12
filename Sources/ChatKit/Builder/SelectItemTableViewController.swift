//
//  SelectItemTableViewController.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class SelectItemTableViewController: UITableViewController {

    var selectedIndex: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    let items: [String]
    
    var itemSelected: ((String, Int) -> ())? = nil
    
    init(selectedIndex: Int?, items: [String]) {
        self.selectedIndex = selectedIndex
        self.items = items
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.registerCell(type: LabelCell.self)
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64.0
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    @objc func done() {
        if let selectedIndex = selectedIndex {
            itemSelected?(items[selectedIndex], selectedIndex)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LabelCell = tableView.dequeueCell(for: indexPath)
        let item = items[indexPath.row]
        cell.titleLabel.text = item
        
        if let selectedIndex = selectedIndex, selectedIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
}
