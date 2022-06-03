//
//  RuleCreationViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 18.05.2022.
//

import UIKit
import Alamofire

class CreateUpdateRuleViewController: UIViewController {
    var owner: OwnerCreationModel?
    var organisationSize: OrganisationSize?
    var organisationName: String?
    var organisationId: UUID?
    
    @IBOutlet var substituteRuleButtons: [UIButton]?
    @IBOutlet var swapRuleButtons: [UIButton]?
    @IBOutlet var checkinRuleButtons: [UIButton]?
    @IBOutlet weak var shiftsToChooseSwitch: UISwitch!
    @IBOutlet weak var maxApplicationsTextfield: UITextField!
    
    var substituteRadioButtonController = RadioButtonController()
    var swapRadioButtonController = RadioButtonController()
    var checkinRadioButtonController = RadioButtonController()
    var radioButtonControllers: [RadioButtonController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        substituteRadioButtonController.buttonsArray = substituteRuleButtons
        swapRadioButtonController.buttonsArray = swapRuleButtons
        checkinRadioButtonController.buttonsArray = checkinRuleButtons
        
        radioButtonControllers = [substituteRadioButtonController, swapRadioButtonController, checkinRadioButtonController]
        
        if let _ = Token.token {
            loadRules()
        }
    }
    
    func loadRules() {
        let requestURL = "\(K.baseURL)\(K.Endpoints.organisationRequest)"
        let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
        
        AF.request(requestURL, method: .get, headers: headers).validate()
            .responseDecodable(of: OrganisationModel.self) { response in
                switch response.result {
                case let .success(organisation):
                    self.selectRules(rules: organisation.rules)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    func selectRules(rules: OrganisationRulesModel) {
        switch rules.substituteMeRule {
        case .prohibited:
            if let option = substituteRuleButtons?.first(where: {$0.tag == 0}) {
                substituteRadioButtonController.selectButton(buttonSelected: option)
            }
        case .needsApproval:
            if let option = substituteRuleButtons?.first(where: {$0.tag == 1}) {
                substituteRadioButtonController.selectButton(buttonSelected: option)
            }
        case .allowed:
            if let option = substituteRuleButtons?.first(where: {$0.tag == 2}) {
                substituteRadioButtonController.selectButton(buttonSelected: option)
            }
        }
        
        switch rules.swapShiftRule {
        case .prohibited:
            if let option = swapRuleButtons?.first(where: {$0.tag == 0}) {
                swapRadioButtonController.selectButton(buttonSelected: option)
            }
        case .needsApproval:
            if let option = swapRuleButtons?.first(where: {$0.tag == 1}) {
                swapRadioButtonController.selectButton(buttonSelected: option)
            }
        case .allowed:
            if let option = swapRuleButtons?.first(where: {$0.tag == 2}) {
                swapRadioButtonController.selectButton(buttonSelected: option)
            }
        }
        
        switch rules.checkInRule {
        case .button:
            if let option = checkinRuleButtons?.first(where: {$0.tag == 0}) {
                checkinRadioButtonController.selectButton(buttonSelected: option)
            }
        case .geo:
            if let option = checkinRuleButtons?.first(where: {$0.tag == 1}) {
                checkinRadioButtonController.selectButton(buttonSelected: option)
            }
        case .photo:
            if let option = checkinRuleButtons?.first(where: {$0.tag == 2}) {
                checkinRadioButtonController.selectButton(buttonSelected: option)
            }
        case .all:
            if let option = checkinRuleButtons?.first(where: {$0.tag == 3}) {
                checkinRadioButtonController.selectButton(buttonSelected: option)
            }
        }
        
        if rules.notAssignedShiftRule == .allowed {
            shiftsToChooseSwitch.isOn = true
            if let maxApplications = rules.maxEmployeeShiftApplication {
                maxApplicationsTextfield.text = "\(maxApplications)"
            }
        }
    }
    
    @IBAction func ruleChosen(_ sender: UIButton) {
        for radioButtonController in radioButtonControllers! {
            if radioButtonController.buttonsArray.contains(sender) {
                radioButtonController.selectButton(buttonSelected: sender)
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let substituteRuleTag = substituteRadioButtonController.selectedButton?.tag,
           let swapRuleTag = swapRadioButtonController.selectedButton?.tag,
           let checkinRuleTag = checkinRadioButtonController.selectedButton?.tag {
            var notAssignedShiftRule: NotAssignedShiftRule?
            var maxNumberOfApplications: Int?
            let substituteRule: SubstituteMeRule = {
                switch substituteRuleTag {
                case 1:
                    return .needsApproval
                case 2:
                    return .allowed
                default:
                    return .prohibited
                }
            }()
            
            let swapRule: SwapShiftRule = {
                switch swapRuleTag {
                case 1:
                    return .needsApproval
                case 2:
                    return .allowed
                default:
                    return .prohibited
                }
            }()
            
            let checkinRule: CheckInRule = {
                switch checkinRuleTag {
                case 1:
                    return .geo
                case 2:
                    return .photo
                case 3:
                    return .all
                default:
                    return .button
                }
            }()
            
            if shiftsToChooseSwitch.isOn {
                notAssignedShiftRule = .allowed
                maxNumberOfApplications = Int(maxApplicationsTextfield.text!)
            } else {
                notAssignedShiftRule = .prohibited
            }
            let rules = OrganisationRulesModel(substituteMeRule: substituteRule, swapShiftRule: swapRule, checkInRule: checkinRule, notAssignedShiftRule: notAssignedShiftRule!, maxEmployeeShiftApplication: maxNumberOfApplications ?? nil)
            
            if let _ = Token.token {
                let requestURL = "\(K.baseURL)\(K.Endpoints.organisationRequest)/rule"
                let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
                
                AF.request(requestURL, method: .put, parameters: rules, encoder: JSONParameterEncoder.default, headers: headers)
                    .validate()
                    .response { response in
                        switch response.result {
                        case .success:
                            print("Rules changed successfuly")
                            self.navigationController?.popViewController(animated: true)
                        case let .failure(error):
                            print(error)
                            debugPrint(response)
                        }
                    }
            } else {
                let organisationRequestParameters = OrganisationRegistrationModel(name: organisationName!, organizationSize: organisationSize!, user: owner!, rules: rules, maxEmployeeShiftApplication: maxNumberOfApplications)
                let requestURL = "\(K.baseURL)\(K.Endpoints.organisationRequest)"
                
                
                AF.request(requestURL, method: .post, parameters: organisationRequestParameters, encoder: JSONParameterEncoder.default).validate().responseData {response in
                    //TODO: Validate Response
                    debugPrint(response)
                    switch response.result {
                    case.success:
                        print("Success!")
                        print(response.value)
                        self.navigationController?.popToRootViewController(animated: true)
                    case let .failure(error):
                        print(error)
                        print(response.value)
                    }
                }
            }
        }
    }
}




