//
//  BuildChatCell.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

class BuildChatCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var duplicateButton: UIButton!
    
    @IBAction func duplicateButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
