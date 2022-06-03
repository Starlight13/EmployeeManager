//
//  ShiftDetailsViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit

class ShiftDetailsViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var shift: ShiftModel?
    var hasAdminRights = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let role = UserRole(rawValue: "\(Token.tokenBody["role"] ?? "")"), role != .employee {
            hasAdminRights = true
        }
        
        if !hasAdminRights {
            navigationItem.rightBarButtonItem = nil
        }
        
        if let shiftStartDay = shift?.shiftStart.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.dateNoYearFormat),
           let shiftEndDay = shift?.shiftFinish.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.dateNoYearFormat) {
            if shiftStartDay == shiftEndDay {
                dateLabel.text = shiftStartDay
            } else {
                dateLabel.text = "\(shiftStartDay)-\(shiftEndDay)"
            }
        }
        
        if let shiftStartTime = shift?.shiftStart.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.hourMinuteFormat),
           let shiftEndTime = shift?.shiftFinish.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.hourMinuteFormat) {
            timeLabel.text = "\(shiftStartTime) - \(shiftEndTime)"
        }
        
        titleLabel.text = shift?.title
        descriptionLabel.text = shift?.description
        userNameLabel.text = "\(shift?.user.firstName ?? "") \(shift?.user.lastName ?? "")"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.reusableCells.ShiftsTable.taskCellNibName, bundle: .main), forCellReuseIdentifier: K.reusableCells.ShiftsTable.taskCell)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.shiftDetailsToUserDetails {
            let destinationVC = segue.destination as! UserDetailTableViewController
            destinationVC.user = shift?.user
        } else if segue.identifier == K.Segues.shiftDetailsToCreateTask {
            let destinationVC = segue.destination as! CreateUpdateTaskViewController
            destinationVC.shift = shift
        } else if segue.identifier == K.Segues.shiftDetailsToEdit {
            let destinationVC = segue.destination as! UpdateShiftViewController
            destinationVC.shift = shift
        }
    }

}

extension ShiftDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasAdminRights {
            return max(shift?.tasks.count ?? 0, 1) + 1
        }
        return max(shift?.tasks.count ?? 0, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasAdminRights && indexPath.row == (max(shift?.tasks.count ?? 0, 1)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.ShiftsTable.addTaskCell)!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.ShiftsTable.taskCell) as! TaskTableViewCell
        if shift?.tasks.count == 0 {
            cell.titleLebel.text = "There are no tasks for this shift"
            cell.descriptionLabel.isHidden = true
            cell.timeLabel.isHidden = true
            return cell
        }
        if let task = shift?.tasks[indexPath.row] {
            cell.titleLebel.text = task.title
            cell.descriptionLabel.text = task.description
            cell.descriptionLabel.isHidden = false
            cell.timeLabel.isHidden = false
            if let taskTime = task.taskTime {
                cell.timeLabel.text = "at \n\(taskTime.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.hourMinuteFormat))"
            } else {
                cell.timeLabel.text = ""
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tasks"
    }
    
}

extension ShiftDetailsViewController: UITableViewDelegate {
    
}
