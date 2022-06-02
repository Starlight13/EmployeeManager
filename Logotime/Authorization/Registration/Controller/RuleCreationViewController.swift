//
//  RuleCreationViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 18.05.2022.
//

import UIKit
import Alamofire

class RuleCreationViewController: UIViewController {
    var owner: OwnerCreationModel?
    var organisationSize: OrganisationSize?
    var organisationName: String?
    
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
            let rules = OrganisationRulesModel(substituteMeRule: substituteRule, swapShiftRule: swapRule, checkInRule: checkinRule, notAssignedShiftRule: notAssignedShiftRule!)
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
//                self.performSegue(withIdentifier: K.Segues.registrationToCreationToMain, sender: self)
            }
        }
    }
}




