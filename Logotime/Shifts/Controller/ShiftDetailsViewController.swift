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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ShiftDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shift?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCells.ShiftsTable.taskCell)!
        return cell
    }
    
    
}

extension ShiftDetailsViewController: UITableViewDelegate {
    
}
