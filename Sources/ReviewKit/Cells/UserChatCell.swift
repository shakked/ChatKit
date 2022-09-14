//
//  UserChatCell.swift
//  
//
//  Created by Zachary Shakked on 9/14/22.
//

import UIKit

class UserChatCell: UITableViewCell, ReusableView {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
