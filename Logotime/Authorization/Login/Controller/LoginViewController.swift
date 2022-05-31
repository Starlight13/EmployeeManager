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
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if EmailValidation.isValid(emailTextField.text!) {
            let requestURL = "\(K.baseURL)\(K.Endpoints.userRequest)/login"
            let loginRequestParameters = LoginModel(email: emailTextField.text!, password: passwordTextField.text!)
            AF.request(requestURL, method: .post, parameters: loginRequestParameters, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseDecodable(of: TokenResponseModel.self) { response in
                    switch response.result {
                    case .success:
                        print("Validation Successful")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.login(token: response.value!.token)
                    case let .failure(error):
                        debugPrint(response)
                        print(error)
                    }
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
