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
    
    var currentIndexPath: IndexPath?
    
    func configure(for theme: ChatTheme) {
        messageLabel.font = theme.bubbleFont
        messageLabel.textColor = theme.meBubbleTextColor
        bubbleView.layer.cornerRadius = theme.bubbleCornerRadius
        bubbleView.backgroundColor = theme.meBubbleColor
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
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let currentIndexPath = currentIndexPath else { return }
        guard !ChatViewController.animatedIndexPaths.contains(currentIndexPath) else { return }
        contentView.transform = CGAffineTransform(translationX: 350, y: 0)
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.80, initialSpringVelocity: 1.1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.contentView.transform = .identity
        })
        
        ChatViewController.animatedIndexPaths.insert(currentIndexPath)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
