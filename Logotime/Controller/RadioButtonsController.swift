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
        self.selectedButton = buttonSelected
        for button in self.buttonsArray {
            if button == buttonSelected {
                button.layer.borderColor = CGColor(red: 256, green: 256, blue: 256, alpha: 1)
                button.layer.borderWidth = 4
                button.isSelected = true
            } else if button.isSelected {
                button.layer.borderWidth = 0
                button.isSelected = false
            }
        }
    }
}
