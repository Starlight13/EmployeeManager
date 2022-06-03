//
//  ShiftDetailsViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import UIKit
import Alamofire

class ShiftDetailsCreateViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    var shiftTimes: [ShiftTimeModel]?
    var asigneeIds: [UUID]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func createShiftsTapped(_ sender: UIButton) {
        if !titleField.text!.isEmpty &&
            !descriptionField.text!.isEmpty {
            
            let requestURL = "\(K.baseURL)\(K.Endpoints.shiftRequest)"
            let parameters = ShiftCreateModel(userIds: asigneeIds ?? [], title: titleField.text!, description: descriptionField.text!, shifts: shiftTimes ?? [])
            let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
            
            print(parameters)
            
            AF.request(requestURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        self.navigationController?.popToRootViewController(animated: true)
                        self.tabBarController?.selectedIndex = 0
                    case let .failure(error):
                        print(error)
                    }
                }
        }
    }
    
}
