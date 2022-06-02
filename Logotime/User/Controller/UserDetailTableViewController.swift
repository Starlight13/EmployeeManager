//
//  UserDetailTableViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

class UserDetailTableViewController: UITableViewController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let role = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"), role == .employee ||
            user?.userRole == .owner {
            navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.UserDetailsTable.userDetailsNameCell) as! UserDetailsHeaderTableViewCell
            cell.userNameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            if let isActive = user?.active, isActive {
                cell.isActiveLabel.text = "Active"
                cell.isActiveLabel.textColor = .green
            } else {
                cell.isActiveLabel.text = "Disabled"
                cell.isActiveLabel.textColor = .red
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.UserDetailsTable.userDetailsPhoneCell) as! UserDetailsPhoneTableViewCell
            cell.phoneNumberLabel.text = user?.phoneNumber
            cell.phoneNumber = user?.phoneNumber
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.UserDetailsTable.userDetailsCell) as! UserDetailsTableViewCell
            if indexPath.row == 2 {
                cell.userProperty.text = "E-mail"
                cell.propertyValue.text = user?.email
            } else if indexPath.row == 3 {
                cell.userProperty.text = "Joined on"
                if let creationDate = user?.creationDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "y-MM-dd'T'H:mm:ss.SSSS"
                    if let date = dateFormatter.date(from: creationDate) {
                        dateFormatter.dateFormat = "MMM d, yyyy"
                        cell.propertyValue.text = dateFormatter.string(from: date)
                    }
                }
            } else {
                cell.userProperty.text = "Position"
                cell.propertyValue.text = user?.userRole.rawValue.lowercased().firstCapitalized
            }
            return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.detailsToEditUser {
            let destinationVC = segue.destination as! CreateUpdateUserViewController
            destinationVC.user = user
        }
    }
    
    
}
