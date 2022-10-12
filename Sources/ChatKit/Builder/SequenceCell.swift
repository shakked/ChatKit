//
//  SequenceCell.swift
//  
//
//  Created by Zachary Shakked on 10/10/22.
//

import UIKit

class SequenceCell: UITableViewCell, ReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
