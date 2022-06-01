//
//  AccountSettingsTableViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import UIKit
import JWTDecode

class AccountSettingsTableViewController: UITableViewController {
    
    let menuForEveryone = [
        MenuItemModel(menuName: "Organisation users", segueIdentifier: K.Segues.menuToUsers)
    ]
    
    var menu: [MenuItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.append(contentsOf: menuForEveryone)
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
            do {
                let jwt = try decode(jwt: Token.token ?? "")
                cell.userNameLabel.text = "\(jwt.body["firstName"] ?? "") \(jwt.body["lastName"] ?? "")"
            } catch {
                print(error)
            }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
