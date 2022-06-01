//
//  UserDetailsPhoneTableViewCell.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import UIKit

class UserDetailsPhoneTableViewCell: UITableViewCell {
    @IBOutlet weak var phoneNumberLabel: UILabel!
    var phoneNumber: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callPressed(_ sender: UIButton) {
        if let url = URL(string: "tel://\(String(describing: phoneNumber ?? ""))"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
