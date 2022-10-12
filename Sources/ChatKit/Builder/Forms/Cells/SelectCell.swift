//
//  SelectCell.swift
//  
//
//  Created by Zachary Shakked on 10/12/22.
//

import UIKit

class SelectCell: UITableViewCell, ReusableView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textColor = .black.withAlphaComponent(0.48)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
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
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.0),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            titleLabel.widthAnchor.constraint(equalTo: descriptionLabel.widthAnchor),
        ])
    }
}
