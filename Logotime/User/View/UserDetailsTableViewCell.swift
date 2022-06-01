//
//  UserDetailsTableViewCell.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var userProperty: UILabel!
    @IBOutlet weak var propertyValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
