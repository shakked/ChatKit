//
//  ChatCell.swift
//  
//
//  Created by Zachary Shakked on 9/12/22.
//

import UIKit

public class ChatCell: UITableViewCell, ReusableView {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
