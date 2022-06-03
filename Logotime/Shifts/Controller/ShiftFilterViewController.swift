//
//  ShiftFilterViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit
import Alamofire

protocol FilterDelegate {
    func filterApplied(userId: UUID?)
}

class ShiftFilterViewController: UIViewController {
    
    var userList = [User]()
    var delegate: FilterDelegate?
    let myId = UUID(uuidString: "\(Token.tokenBody["userId"] ?? "")")

    @IBOutlet weak var userPicker: UIPickerView!
    @IBOutlet weak var modalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPicker.dataSource = self
        userPicker.delegate = self
        
        loadData()
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
    
    //MARK: - Load data
    func loadData() {
        let url = "\(K.baseURL)\(K.Endpoints.userRequest)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: Token.token ?? "")
        ]
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [User].self) { response in
                switch response.result {
                case let .success(organisationUsers):
                    print("Success")
                    self.userList = organisationUsers
                    self.userList = self.userList.sorted { $0.lastName < $1.firstName }
                    self.userPicker.reloadAllComponents()
                case let .failure(error):
                    if response.response?.statusCode == 401 {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.logout()
                    }
                    print(error)
                }
            }
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
        let selected = userPicker.selectedRow(inComponent: 0)
        switch selected {
        case 0: delegate?.filterApplied(userId: nil)
        case 1: delegate?.filterApplied(userId: myId)
        default: delegate?.filterApplied(userId: userList[selected-2].id)
        }
        dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != modalView {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension ShiftFilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userList.count + 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Unassigned"
        }
        if row == 1 {
            return "Me"
        }
        let user = userList[row - 2]
        return "\(user.lastName) \(user.firstName)"
    }
}
