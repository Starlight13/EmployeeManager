//
//  LoginViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 09.05.2022.
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: WelcomeViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if isValidEmail(emailTextField.text!) {
            let requestURL = "\(K.baseURL)\(K.Endpoints.userRequest)/login"
            let loginRequestParameters = LoginModel(email: emailTextField.text!, password: passwordTextField.text!)
            AF.request(requestURL, method: .post, parameters: loginRequestParameters, encoder: JSONParameterEncoder.default).validate().response {response in
                //TODO: Validate Response
                debugPrint(response)
                self.performSegue(withIdentifier: K.Segues.loginToMain, sender: self)
            }
        } else {
            print("Invalid email")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
