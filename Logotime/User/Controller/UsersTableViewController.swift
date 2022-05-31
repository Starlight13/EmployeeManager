//
//  OrganisationUsersTableViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import UIKit
import Alamofire
import JWTDecode

class UsersTableViewController: UITableViewController {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var userList = [OrganisationUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jwt = try decode(jwt: Token.token ?? "")
            if let role = UserRole(rawValue: "\(jwt.body["userRole"])") {
                if role == .employee {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
        } catch {
            print(error)
        }
        
        tableView.register(UINib(nibName: K.reusableCells.userCellNibName, bundle: nil), forCellReuseIdentifier: K.reusableCells.userCell)
        
        loadData()
        
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.userCell, for: indexPath) as! UserTableViewCell
         let user = userList[indexPath.row]
         cell.userNameLabel.text = "\(user.lastName) \(user.firstName)"
         cell.userRoleLabel.text = "(\(user.userRole.rawValue.lowercased()))"
         return cell
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
    
    func loadData() {
        print("Loading data")
        let url = "\(K.baseURL)\(K.Endpoints.userRequest)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: Token.token ?? "")
        ]
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [OrganisationUser].self) { response in
                switch response.result {
                case let .success(organisationUsers):
                    self.userList = organisationUsers
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                case let .failure(error):
                    if response.response?.statusCode == 401 {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.logout()
                    }
                    print(error)
                }
            }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadData()
    }
    
    
}
