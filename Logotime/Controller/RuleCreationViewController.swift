//
//  RuleCreationViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 18.05.2022.
//

import UIKit

class RuleCreationViewController: UIViewController {
    var owner: OwnerCreationModel?
    var organisationSize: OrganisationSize?
    var organisationName: String?
    
    
    @IBOutlet weak var substituteNo: UIButton!
    @IBOutlet weak var substituteApproval: UIButton!
    @IBOutlet weak var substituteYes: UIButton!
    
    
    @IBOutlet weak var swapNo: UIButton!
    @IBOutlet weak var swapApproval: UIButton!
    @IBOutlet weak var swapYes: UIButton!
    
    
    @IBOutlet weak var checkinNo: UIButton!
    @IBOutlet weak var checkinGeo: UIButton!
    @IBOutlet weak var checkinPhoto: UIButton!
    @IBOutlet weak var checkinBoth: UIButton!
    
    @IBOutlet weak var shiftsToChooseSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(owner.debugDescription)
        
        print(organisationSize)
        print(organisationName)
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

}
