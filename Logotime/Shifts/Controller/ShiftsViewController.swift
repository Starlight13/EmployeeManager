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
        updateLabel()
        
        loadData(for: nil, unasigned: nil)
    }
    


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.shiftToDetails {
            let destinationVC = segue.destination as! ShiftDetailsViewController
            let selectedShift = shifts[tableView.indexPathForSelectedRow?.row ?? 0]
            destinationVC.shift = selectedShift
        } else if segue.identifier == K.Segues.shiftsToFilter {
            let destinationVC = segue.destination as! ShiftFilterViewController
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Actions
    
    func updateLabel() {
        dateIntervalLabel.text = "\(startDate?.changeDateFormat(to: K.dateFormats.dateNoYearFormat) ?? "")-\(endDate?.changeDateFormat(to: K.dateFormats.dateNoYearFormat) ?? "")"
    }
    
    @IBAction func changeWeekPressed(_ sender: UIButton) {
        let calendar = Calendar.current
        
        var changeBy = 1
        if sender.tag == 0 {
            changeBy = -1
        }
        
        if let newStartDate = calendar.date(byAdding: .weekOfMonth, value: changeBy, to: startDate ?? Date()),
           let newEndDate = calendar.date(byAdding: .weekOfMonth, value: changeBy, to: endDate ?? Date()) {
            startDate = newStartDate
            endDate = newEndDate
            updateLabel()
            loadData(for: nil, unasigned: nil)
        }
    }
    
    @IBAction func clearFilterPressed(_ sender: UIButton) {
        loadData()
    }
    
    //MARK: - Load data
    
    func loadData(for userId: UUID? = nil, unasigned: Bool? = nil) {
        if let startFormatted = startDate?.changeDateFormat(to: K.dateFormats.dateFormat),
           let endFormatted = endDate?.changeDateFormat(to: K.dateFormats.dateFormat) {
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
        cell.startTimeLabel.text = shift.shiftStart.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.userDateTime)
        cell.endTimeLabel.text = shift.shiftFinish.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.userDateTime)
        return cell
    }
    
}

extension ShiftsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.shiftToDetails, sender: self)
    }
}

extension ShiftsViewController: FilterDelegate {
    func filterApplied(userId: UUID?) {
        if let userId = userId {
            loadData(for: userId)
        } else {
            loadData(unasigned: true)
        }
    }
}
