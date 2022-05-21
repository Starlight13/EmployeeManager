//
//  LoginViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 09.05.2022.
//

import Foundation
import UIKit

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
            let url = URL(string: K.baseURL)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameters: [String: Any] = [
                "email": emailTextField.text!,
                "password": passwordTextField.text!
            ]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let e = error {
                    print(e)
                } else {
                    print(String(data: data!, encoding: .utf8))
                }
            }
            
            task.resume()
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
