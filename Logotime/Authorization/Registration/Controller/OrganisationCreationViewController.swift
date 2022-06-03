//
//  OrganisationCreationViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 17.05.2022.
//

import UIKit

class OrganisationCreationViewController: UIViewController {
    
    var owner: OwnerCreationModel?
    var sizeRadioButtonsController = RadioButtonController()
    var organisationSize: OrganisationSize?
    var organisationName: String?
    
    @IBOutlet weak var organisationNameTextField: UITextField!
    @IBOutlet weak var smallOrganisationButton: UIButton!
    @IBOutlet weak var mediumOrganisationButton: UIButton!
    @IBOutlet weak var bigOrganisationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sizeRadioButtonsController.buttonsArray = [smallOrganisationButton, mediumOrganisationButton, bigOrganisationButton]
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.organisationCreationToRuleCreation {
            let destinationVC = segue.destination as! CreateUpdateRuleViewController
            destinationVC.owner = owner
            destinationVC.organisationSize = organisationSize
            destinationVC.organisationName = organisationName
        }
    }
    
    @IBAction func sizeChosen(_ sender: UIButton) {
        sizeRadioButtonsController.selectButton(buttonSelected: sender)
    }
    
    
    @IBAction func nextStepPressed(_ sender: UIButton) {
        if !organisationNameTextField.text!.isEmpty,
           let organisationSizeSelected = sizeRadioButtonsController.selectedButton {
            organisationName = organisationNameTextField.text!
            switch organisationSizeSelected.tag {
            case 0:
                organisationSize = .small
            case 1:
                organisationSize = .medium
            case 2:
                organisationSize = .big
            default:
                organisationSize = .small
            }
            performSegue(withIdentifier: K.Segues.organisationCreationToRuleCreation, sender: self)
        }
    }
    
}
