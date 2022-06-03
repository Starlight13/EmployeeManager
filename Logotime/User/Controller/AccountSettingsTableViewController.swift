//
//  AccountSettingsTableViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import UIKit

class AccountSettingsTableViewController: UITableViewController {
    
    let menuForEveryone: [MenuItemModel] = [
        MenuItemModel(menuName: "Organisation users", segueIdentifier: K.Segues.menuToUsers)
    ]
    
    let menuForOwner: [MenuItemModel] = [
        MenuItemModel(menuName: "Change rules", segueIdentifier: K.Segues.settingsToChangeRules)
    ]
    
    let menuForAdmin: [MenuItemModel] = [
        MenuItemModel(menuName: "Shift submitions", segueIdentifier: K.Segues.settingsToSubmitions)
    ]
    
    var menu: [MenuItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.append(contentsOf: menuForEveryone)
        
        if let role = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")") {
            if role == .admin || role == .owner {
                menu.append(contentsOf: menuForAdmin)
            }
            if role == .owner {
                menu.append(contentsOf: menuForOwner)
            }
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menu.count + 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.menuHeaderCell) as! MenuHeaderTableViewCell
            cell.userNameLabel.text = "\(Token.tokenBody["firstName"] ?? "") \(Token.tokenBody["lastName"] ?? "")"
            return cell
        } else if indexPath.row == (menu.count + 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.logoutCell)!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.menuItemCell) as! MenuItemTableViewCell
            cell.menuItemLabel.text = menu[indexPath.row - 1].menuName
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reuseIdentifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier
        if reuseIdentifier == K.reusableCells.menuItemCell{
            performSegue(withIdentifier: menu[indexPath.row - 1].segueIdentifier, sender: self)
        } else if reuseIdentifier == K.reusableCells.logoutCell {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.logout()
        }
    }
}
