//
//  AddOptionCell.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class AddOptionCell: UITableViewCell, ReusableView {
    
    lazy var button: PowerButton = {
        let button = PowerButton()
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20.0, weight: .bold))
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)!
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(hex: "#28CB68")
        button.setTitle("", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(button)
        addSubview(titleLabel)
                
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            button.heightAnchor.constraint(equalToConstant: 24.0),
            button.widthAnchor.constraint(equalToConstant: 24.0),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.button.trailingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}



