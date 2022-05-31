//
//  CreateUserViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import UIKit
import Alamofire

class CreateUserViewController: UIViewController {

    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPhoneField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userFirstNameField: UITextField!
    @IBOutlet weak var userLastNameField: UITextField!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func registerUserTapped(_ sender: Any) {
        let email = userEmailField.text!
        if (EmailValidation.isValid(email)) &&
            !userPhoneField.text!.isEmpty &&
            !userPasswordField.text!.isEmpty &&
            !userFirstNameField.text!.isEmpty &&
            !userLastNameField.text!.isEmpty {
            var userRole: UserRole
            
            if isAdminSwitch.isOn {
                userRole = UserRole.admin
            } else {
                userRole = UserRole.employee
            }
            
            let requestURL = "\(K.baseURL)\(K.Endpoints.userRequest)"
            let requestParams = CreateUserRequest(lastName: userLastNameField.text!, firstName: userFirstNameField.text!, email: email, password: userPasswordField.text!, phoneNumber: userPhoneField.text!, userRole: userRole)
            let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
            
            AF.request(requestURL, method: .post, parameters: requestParams, encoder: JSONParameterEncoder.default, headers: headers).validate().responseData {response in
                //TODO: Validate Response
                debugPrint(response)
                switch response.result {
                case.success:
                    print("Success!")
                    print(response.value)
                    self.dismiss(animated: true)
                case let .failure(error):
                    print(error)
                    print(response.value)
                }
            }
        }
    }
}
