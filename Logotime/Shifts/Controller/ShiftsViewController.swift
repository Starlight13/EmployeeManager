//
//  ShiftsViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 30.05.2022.
//

import UIKit
import Alamofire


class ShiftsViewController: UIViewController {

    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var shifts = [ShiftModel]()
    
    var startDate = Date().startOfWeek
    var endDate = Date().endOfWeek
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.reusableCells.ShiftsTable.shiftCellNibName, bundle: nil), forCellReuseIdentifier: K.reusableCells.ShiftsTable.shiftCell)
        
        loadData(for: nil, unasigned: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    
    @IBAction func changeWeekPressed(_ sender: UIButton) {
    }
    
    @IBAction func filterPressed(_ sender: UIButton) {
    }
    
    @IBAction func clearFilterPressed(_ sender: UIButton) {
    }
    
    //MARK: - Load data
    
    func loadData(for userId: UUID?, unasigned: Bool?) {
        if let startFormatted = startDate?.toServerDateOnlyFormat(),
           let endFormatted = endDate?.toServerDateOnlyFormat() {
            let requestURL = "\(K.baseURL)\(K.Endpoints.shiftRequest)"
            let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
            var parameters: [String : String] = [
                "from": startFormatted,
                "to": endFormatted
            ]
            
            if let userId = userId {
                parameters["userId"] = "\(userId)"
            }
            if let unasigned = unasigned {
                parameters["unassigned"] = "\(unasigned)"
            }
            print(parameters)
            AF.request(requestURL, method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: [ShiftModel].self) { response in
                    switch response.result {
                    case let .success(shifts):
                        print("Success")
                        self.shifts = shifts
                        print(shifts)
                        self.tableView.reloadData()
                    case let .failure(error):
                        if response.response?.statusCode == 401 {
                            (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).logout()
                        }
                        print(error)
                        print(response.response)
                    }
                }
        }
    }
    
    func getUser(for shift: ShiftModel) {
        let requestURL = "\(K.baseURL)\(K.Endpoints.userRequest)/\(shift.user.id)"
        let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
        
        var userForShift: User?
        
        AF.request(requestURL, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: User.self) { response in
                    switch response.result {
                    case let .success(user):
                        print("Found user")
                        userForShift = user
                    case let .failure(error):
                        print(error)
                }
            }
    }
}

extension ShiftsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cells")
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.ShiftsTable.shiftCell) as! ShiftTableViewCell
        let shift = shifts[indexPath.row]
        let user = shift.user
        
        cell.userNameLabel.text = "\(user.firstName) \(user.lastName)"
        cell.taskLabel.text = {
            switch shift.tasks.count {
            case 0: return "No tasks"
            case 1: return "1 task"
            default: return "\(shift.tasks.count) tasks"
            }
        }()
        cell.startTimeLabel.text = shift.shiftStart.changeDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", toFormat: "HH:mm")
        cell.endTimeLabel.text = shift.shiftFinish.changeDateFormat(fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", toFormat: "HH:mm")
        return cell
    }
    
}

extension ShiftsViewController: UITableViewDelegate {
    
}
