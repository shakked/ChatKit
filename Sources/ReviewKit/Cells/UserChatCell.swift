//
//  UserChatCell.swift
//  
//
//  Created by Zachary Shakked on 9/14/22.
//

import UIKit

class UserChatCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var meLabel: UILabel!
    
    func configure(for theme: ChatTheme) {
        messageLabel.backgroundColor = theme.meBubbleColor
        messageLabel.font = theme.bubbleFont
        messageLabel.textColor = theme.meBubbleTextColor
        bubbleView.layer.cornerRadius = theme.bubbleCornerRadius
        meLabel.textColor = theme.meTextColor
        meLabel.backgroundColor = theme.meBackgroundColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
