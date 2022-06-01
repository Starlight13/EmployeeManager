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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jwt = try decode(jwt: Token.token ?? "")
            if let role = UserRole(rawValue: "\(jwt.body["role"] ?? "")") {
                print(role)
                if role == .admin || role == .owner {
                    print("has rights")
                    self.navigationItem.rightBarButtonItem = addBarButton
                } else {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
        } catch {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.logout()
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
        
        if user.active {
            cell.contentView.layer.opacity = 1
        } else {
            cell.contentView.layer.opacity = 0.4
        }
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.userListToDetail, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.userListToDetail {
            let destinationVC = segue.destination as! UserDetailTableViewController
            destinationVC.user = userList[tableView.indexPathForSelectedRow?.row ?? 0]
        }
    }
    
    //MARK: - Loading data
    
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
