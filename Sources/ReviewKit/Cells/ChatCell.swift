//
//  ChatCell.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public class ChatCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var bottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    func configure(for theme: ChatTheme) {
        messageLabel.font = theme.bubbleFont
        bubbleView.backgroundColor = theme.appBubbleColor
        messageLabel.textColor = theme.appBubbleTextColor
        bubbleView.layer.cornerRadius = theme.bubbleCornerRadius
        profilePictureImageView.image = theme.profilePicture
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
