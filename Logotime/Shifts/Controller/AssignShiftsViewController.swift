//
//  AssignShiftsViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import UIKit
import Alamofire

class AssignShiftsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var shiftTimes: [ShiftTimeModel]?
    
    var selectedUsers = [OrganisationUser]()
    var users = [OrganisationUser]()
    var filteredUsers = [OrganisationUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        print(shiftTimes)
        loadData()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.assignShiftToDetails {
            let destinationVC = segue.destination as! ShiftDetailsViewController
            destinationVC.shiftTimes = shiftTimes
            let asigneeIds = selectedUsers.map { $0.id }
            destinationVC.asigneeIds = asigneeIds
        }
    }
    
    //MARK: - Load data
    
    func loadData() {
        let url = "\(K.baseURL)\(K.Endpoints.userRequest)"
        let headers: HTTPHeaders = [
            .authorization(bearerToken: Token.token ?? "")
        ]
        AF.request(url, method: .get, headers: headers).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [OrganisationUser].self) { response in
                switch response.result {
                case let .success(organisationUsers):
                    self.users = organisationUsers
                    self.filteredUsers = organisationUsers
                    self.tableView.reloadData()
                case let .failure(error):
                    if response.response?.statusCode == 401 {
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.logout()
                    }
                    print(error)
                }
            }
    }
    
    
    @IBAction func nextStepPressed(_ sender: Any) {
        let requestURL = "\(K.baseURL)\(K.Endpoints.organisationRequest)"
        let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
        
        AF.request(requestURL, method: .get, headers: headers).validate()
            .responseDecodable(of: OrganisationModel.self) { response in
                switch response.result {
                case let .success(organisation):
                    if organisation.rules.notAssignedShiftRule == .prohibited && self.selectedUsers.count == 0 {
                        let alert = UIAlertController(title: "No assignees selected", message: "Your organisation does not allow not assigned shifts. If you want to create shifts with no asignees, change the organisation rule.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.performSegue(withIdentifier: K.Segues.assignShiftToDetails, sender: self)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
}

//MARK: - Table View Data Source

extension AssignShiftsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return max(selectedUsers.count, 1)
        }
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Asignees"
        }
        return "Employees"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.AssignShift.assignShiftCell) ?? UITableViewCell()
        var user: OrganisationUser
        
        if indexPath.section == 0 {
            cell.selectionStyle = .none
            
            if selectedUsers.count == 0 {
                cell.textLabel?.text = "No asignees selected"
                cell.textLabel?.textColor = .gray
                cell.detailTextLabel?.text = ""
                return cell
            }
            
            user = selectedUsers[indexPath.row]
        } else {
            user = filteredUsers[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.selectionStyle = .default
        }
        
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = "(\(user.userRole.rawValue.lowercased()))"
        
        return cell
    }
}

//MARK: - Table view delegate

extension AssignShiftsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if !selectedUsers.contains(filteredUsers[indexPath.row]) {
                selectedUsers.insert(filteredUsers[indexPath.row], at: 0)
                tableView.reloadData()
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedUsers.remove(at: indexPath.row)
            if selectedUsers.count == 0 {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = "No asignees selected"
                cell?.textLabel?.textColor = .gray
                cell?.detailTextLabel?.text = ""
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && selectedUsers.count != 0 { return true }
        return false
    }
}

//MARK: - Search bar delegate

extension AssignShiftsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            filteredUsers = users.filter({ user in
                let name = "\(user.firstName) \(user.lastName)".lowercased()
                return name.contains(searchBar.text!.lowercased())
            })
        }
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filteredUsers = users
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
