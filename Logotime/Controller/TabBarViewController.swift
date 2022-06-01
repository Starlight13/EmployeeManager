//
//  TabBarViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let role = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"), role != .employee {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let addShiftNavVC = mainStoryboard.instantiateViewController(withIdentifier: K.VC.addShiftNavVC)
            let icon = UITabBarItem(title: "Add shift", image: UIImage(systemName: "plus.app"), tag: 2)
            addShiftNavVC.tabBarItem = icon
            self.viewControllers?.insert(addShiftNavVC, at: 1)
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

}
