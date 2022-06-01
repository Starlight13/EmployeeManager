//
//  CreateUserViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import UIKit
import Alamofire

class CreateUpdateUserViewController: UIViewController {
    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPhoneField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userFirstNameField: UITextField!
    @IBOutlet weak var userLastNameField: UITextField!
    @IBOutlet weak var isAdminSwitch: UISwitch!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageTitleLabel: UILabel!
    
    var user: OrganisationUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = user {
            userEmailField.text = user?.email
            userPhoneField.text = user?.phoneNumber
            userFirstNameField.text = user?.firstName
            userLastNameField.text = user?.lastName
            if user?.userRole == .owner ||  user?.userRole == .admin {
                isAdminSwitch.isOn = true
            } else {
                isAdminSwitch.isOn = false
            }
            
            if let currentUserRole = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"), currentUserRole == .owner {
                isAdminSwitch.isEnabled = true
            } else {
                isAdminSwitch.isEnabled = false
            }
            
            passwordView?.removeFromSuperview()
            actionButton.setTitle("Edit User", for: .normal)
            pageTitleLabel.text = "Edit User"
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func actionPressed(_ sender: Any) {
        let email = userEmailField.text!
        if (EmailValidation.isValid(email)) &&
            !userPhoneField.text!.isEmpty &&
            !userFirstNameField.text!.isEmpty &&
            !userLastNameField.text!.isEmpty {
            var userRole: UserRole
            
            if isAdminSwitch.isOn {
                userRole = UserRole.admin
            } else {
                userRole = UserRole.employee
            }
            
            if let _ = user {
                let requestURL = "\(K.baseURL)\(K.Endpoints.userRequest)/\(user!.id)"
                let requestParams = UpdateUserRequest(lastName: userLastNameField.text!, firstName: userFirstNameField.text!, email: email, phoneNumber: userPhoneField.text!)
                let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
                
                AF.request(requestURL, method: .put, parameters: requestParams, encoder: JSONParameterEncoder.default, headers: headers).validate().responseData {response in
                    //TODO: Validate Response
                    debugPrint(response)
                    switch response.result {
                    case.success:
                        print(UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"))
                        print(self.user!.id)
                        if let role = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"), role == .owner{
                            let userRolerequestURL = "\(K.baseURL)\(K.Endpoints.userRequest)/userRole"
                            let userRolerequestParams = UpdateUserRoleRequest(userId: self.user?.id ?? "", userRole: userRole)
                            AF.request(userRolerequestURL, method: .patch, parameters: userRolerequestParams, encoder: JSONParameterEncoder.default, headers: headers).validate().responseData { response in
                                print("Success!")
                                print(response.value)
                                self.dismiss(animated: true)
                            }
                        } else {
                            print("Success!")
                            print(response.value)
                            self.dismiss(animated: true)
                        }
                    case let .failure(error):
                        print(error)
                        print(response.value)
                    }
                }
            } else {
                if !userPasswordField.text!.isEmpty {
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
    }
}
