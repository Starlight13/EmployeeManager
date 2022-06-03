//
//  UnassignedShiftViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit
import Alamofire

class UnassignedShiftViewController: UIViewController {

    @IBOutlet weak var dateIntrvalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var unassignedShifts: [ShiftModel]?
    
    var startDate = Date().startOfWeek
    var endDate = Date().endOfWeek
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.reusableCells.ShiftsTable.shiftCellNibName, bundle: nil), forCellReuseIdentifier: K.reusableCells.ShiftsTable.shiftCell)
        updateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateLabel() {
        dateIntrvalLabel.text = "\(startDate?.changeDateFormat(to: K.dateFormats.dateNoYearFormat) ?? "")-\(endDate?.changeDateFormat(to: K.dateFormats.dateNoYearFormat) ?? "")"
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
            loadData()
        }
    }
    
    func loadData() {
        if let startFormatted = startDate?.changeDateFormat(to: K.dateFormats.dateFormat),
           let endFormatted = endDate?.changeDateFormat(to: K.dateFormats.dateFormat) {
                let requestURL = "\(K.baseURL)\(K.Endpoints.shiftRequest)"
                let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
                var parameters: [String : String] = [
                    "from": startFormatted,
                    "to": endFormatted,
                    "unassigned": "true"
                ]
                
            
                AF.request(requestURL, method: .get, parameters: parameters, headers: headers)
                    .validate()
                    .responseDecodable(of: [ShiftModel].self) { response in
                        switch response.result {
                        case let .success(shifts):
                            print("Success")
                            self.unassignedShifts = shifts
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

extension UnassignedShiftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(unassignedShifts?.count ?? 0, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.ShiftsTable.shiftCell) as! ShiftTableViewCell
        cell.taskLabel.isHidden = true
        if unassignedShifts?.count == 0 {
            cell.userNameLabel.text = "There are no unassigned shifts for this period"
            cell.startTimeLabel.isHidden = true
            cell.endTimeLabel.isHidden = true
            return cell
        } else {
            cell.startTimeLabel.isHidden = false
            cell.endTimeLabel.isHidden = false
        }
        
        if let shift = unassignedShifts?[indexPath.row] {
            if let user = shift.user {
                cell.userNameLabel.text = "\(user.firstName) \(user.lastName)"
            } else {
                cell.userNameLabel.text = "Unassigned"
            }
            
            cell.startTimeLabel.text = shift.shiftStart.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.userDateTime)
            cell.endTimeLabel.text = shift.shiftFinish.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.userDateTime)
            return cell
        }
        
        return cell
    }
    
    
}

extension UnassignedShiftViewController: UITableViewDelegate {
    
}
