//
//  FormViewController.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

class FormViewController: UITableViewController {

    var form: Form
    var finished: ((Form) -> ())?
    var isValid: ((Form) -> (Bool, String?))?
    
    init(form: Form) {
        self.form = form
        super.init(style: .plain)
    }
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(errorLabel)
        view.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.backgroundColor = .white
        tableView.registerCell(type: TextFieldInputCell.self)
        tableView.registerCell(type: TextViewInputCell.self)
        tableView.registerCell(type: AddOptionCell.self)
        tableView.registerCell(type: OptionTextCell.self)
        tableView.registerCell(type: LabelCell.self)
        tableView.registerCell(type: SelectCell.self)
        tableView.contentInset = UIEdgeInsets(top: 24.0, left: 0, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonPressed() {
        self.finished?(form)
    }
    
    func somethingChanged() {
        if let isValidTuple = self.isValid?(form) {
            let isValid = isValidTuple.0
            navigationItem.rightBarButtonItem?.tintColor = isValid ? .systemBlue : .red
            
            if let errorMessage = isValidTuple.1 {
                errorLabel.text = errorMessage
            } else {
                errorLabel.text = ""
            }
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formItem = form.items[indexPath.row]

        if let formItem = formItem as? LabelFormItem {
            let cell: LabelCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.text = formItem.text
            cell.titleLabel.textColor = formItem.textColor
            cell.titleLabel.font = formItem.font
            return cell
            
        } else if var textInputFormItem = formItem as? TextInputFormItem {
            
            if textInputFormItem.multiLine {
                // Multi-line text
                let cell: TextViewInputCell = tableView.dequeueCell(for: indexPath)
                cell.titleLabel.text = textInputFormItem.title
                cell.textView.placeholder = textInputFormItem.placeholder
                if let text = textInputFormItem.value {
                    cell.textView.text = text
                }
                cell.textView.text = textInputFormItem.value
                cell.textChanged = { [unowned self] newText in
                    self.tableView.performBatchUpdates(nil)
                    textInputFormItem.value = newText
                    self.somethingChanged()
                }
                return cell
            } else {
                // Single-line text
                let cell: TextFieldInputCell = tableView.dequeueCell(for: indexPath)
                cell.titleLabel.text = textInputFormItem.title
                cell.textField.placeholder = textInputFormItem.placeholder
                cell.textField.text = textInputFormItem.value
                cell.textChanged = { [unowned self] _ in
                    self.somethingChanged()
                }
                return cell
            }
        } else if let variableTextOptionsFormItem = formItem as? VariableTextOptionsFormItem {
            
            let cell: AddOptionCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.text = variableTextOptionsFormItem.addOptionTitle
            return cell
            
        } else if let textOption = formItem as? TextOption, let parent = textOption.parent {
            let cell: OptionTextCell = tableView.dequeueCell(for: indexPath)
            cell.textField.placeholder = parent.placeholder
            cell.textField.text = textOption.value
            cell.delete = {
                if let myIndex = self.form.items.firstIndex(where: { ($0 as? TextOption)?.hash == textOption.hash  }) {
                    self.form.items.remove(at: myIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: myIndex, section: 0)], with: .automatic)
                }
            }
            
            return cell
            
        } else if let selectFormItem = formItem as? SelectFormItem {
            let cell: SelectCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.text = selectFormItem.title
            cell.descriptionLabel.text = selectFormItem.value ?? "View Options"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        fatalError()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let formItem = form.items[indexPath.row]
        if let selectFormItem = formItem as? SelectFormItem {
            var selectIndex: Int? = nil
            if let selectedFormItemValue = selectFormItem.value {
                selectIndex = selectFormItem.items.firstIndex(of: selectedFormItemValue)
            }
            
            let selectItemTableView = SelectItemTableViewController(selectedIndex: selectIndex, items: selectFormItem.items)
            selectItemTableView.navigationItem.title = selectFormItem.title
            selectItemTableView.itemSelected = { (value, index) in
                self.form.items[indexPath.row] = SelectFormItem(title: selectFormItem.title, items: selectFormItem.items, value: value)
                self.tableView.reloadData()
            }
            navigationController?.pushViewController(selectItemTableView, animated: true)
        }
        
        
        if let textInputCell = cell as? TextFieldInputCell {
            textInputCell.textField.becomeFirstResponder()
        } else if let _ = cell as? AddOptionCell, let variableTextOption = form.items[indexPath.row] as? VariableTextOptionsFormItem  {
            var currentIndex = indexPath.row
            
            while (true) {
                currentIndex += 1
                
                guard currentIndex < form.items.count else {
                    break
                }
                
                let currentFormItem = form.items[currentIndex]
                
                if let _ = currentFormItem as? TextOption {
                    continue
                } else {
                    break
                }
            }
            var newTextOption = TextOption(title: "", placeholder: variableTextOption.placeholder, value: "")
            newTextOption.parent = variableTextOption
            self.form.items.insert(newTextOption, at: currentIndex)
            self.tableView.insertRows(at: [IndexPath(row: currentIndex, section: 0)], with: .automatic)
        } else if let textOptionCell = cell as? OptionTextCell {
            textOptionCell.textField.becomeFirstResponder()
        } else if let textViewInputCell = cell as? TextViewInputCell {
            textViewInputCell.textView.becomeFirstResponder()
        } else if let textInputCell = cell as? TextFieldInputCell {
            textInputCell.textField.becomeFirstResponder()
        }
    }
}
