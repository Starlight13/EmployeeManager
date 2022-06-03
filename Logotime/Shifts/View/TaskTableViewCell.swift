//
//  TaskTableViewCell.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLebel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
