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
    
    var shouldAnimate: Bool = true
    
    func configure(for theme: ChatTheme) {
        clipsToBounds = false
        contentView.clipsToBounds = false
        superview?.clipsToBounds = false
        
        messageLabel.font = theme.bubbleFont
        messageLabel.textColor = theme.meBubbleTextColor
        bubbleView.layer.cornerRadius = theme.bubbleCornerRadius
        bubbleView.backgroundColor = theme.meBubbleColor
        meLabel.textColor = theme.meTextColor
        meLabel.backgroundColor = theme.meBackgroundColor
        guard shouldAnimate else { return }
        contentView.transform = CGAffineTransform(translationX: 0, y: 200)
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
        guard shouldAnimate else { return }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 1.3, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.contentView.transform = .identity
        }, completion: { _ in
            
        })
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.shouldAnimate = true
    }
    
}
