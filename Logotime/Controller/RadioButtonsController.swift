//
//  RadioButtonsController.swift
//  Logotime
//
//  Created by dsadas asdasd on 17.05.2022.
//

import Foundation
import UIKit

class RadioButtonController: NSObject {
    var buttonsArray: [UIButton]!
    var selectedButton: UIButton?

    func selectButton(buttonSelected: UIButton) {
        for b in buttonsArray {
            if b == buttonSelected {
                selectedButton = b
                b.isSelected = true
                b.backgroundColor = UIColor(named: K.Colors.primaryColor)
            } else {
                b.isSelected = false
                b.backgroundColor = UIColor(named: K.Colors.secondaryColor)
            }
        }
    }
}
