//
//  UserRegisterViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 17.05.2022.
//

import UIKit

class OwnerCreationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextFIeld: UITextField!
    
    var owner: OwnerCreationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextFIeld.delegate = self
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.userCreationToOrganisationCreation {
            let destinationVC = segue.destination as! OrganisationCreationViewController
            destinationVC.owner = owner
        }
    }

    @IBAction func nextStepPressed(_ sender: UIButton) {
        if EmailValidation.isValid(emailTextField.text!) &&
           !phoneNumberTextField.text!.isEmpty &&
           !passwordTextField.text!.isEmpty &&
           !firstNameTextField.text!.isEmpty &&
           !lastNameTextFIeld.text!.isEmpty {
             owner = OwnerCreationModel(email: emailTextField.text!, phoneNumber: phoneNumberTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextFIeld.text!)
            performSegue(withIdentifier: K.Segues.userCreationToOrganisationCreation, sender: self)
        }
    }
}

extension OwnerCreationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
