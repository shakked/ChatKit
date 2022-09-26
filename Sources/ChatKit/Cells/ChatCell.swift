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
    
    static var didAnimate: Set<String> = Set<String>()
    
    var shouldAnimate: Bool = true
    var didGenerateImpact: Bool = false
    
    func configure(for theme: ChatTheme) {
        messageLabel.font = theme.bubbleFont
        bubbleView.backgroundColor = theme.appBubbleColor
        messageLabel.textColor = theme.appBubbleTextColor
        bubbleView.layer.cornerRadius = theme.bubbleCornerRadius
        profilePictureImageView.image = theme.profilePicture
        guard shouldAnimate else { return }
        contentView.transform = CGAffineTransform(translationX: -350, y: 0)
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
        guard shouldAnimate else { return }
        if !didGenerateImpact {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            didGenerateImpact = true
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.80, initialSpringVelocity: 1.1, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.contentView.transform = .identity
        }, completion: { _ in
            
        })
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        shouldAnimate = true
        didGenerateImpact = false
    }
    
}
