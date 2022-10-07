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
        
    
    var didGenerateImpact: Bool = false
    var currentIndexPath: IndexPath?
    
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
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
            
        guard let currentIndexPath = currentIndexPath else { return }
        
        if !didGenerateImpact {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            didGenerateImpact = true
        }
        
        guard !ChatViewController.animatedIndexPaths.contains(currentIndexPath) else { return }
        
        contentView.transform = CGAffineTransform(translationX: -350, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 1.1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.contentView.transform = .identity
        })
        
        ChatViewController.animatedIndexPaths.insert(currentIndexPath)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        didGenerateImpact = false
    }
    
}
