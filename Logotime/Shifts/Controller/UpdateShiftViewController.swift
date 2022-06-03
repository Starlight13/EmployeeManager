//
//  UpdateShiftViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit
import DatePickerDialog
import Alamofire

class UpdateShiftViewController: UIViewController {
    
    var shift: ShiftModel?
    var shiftStart: Date?
    var shiftEnd: Date?
    var userId: UUID?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var assigneeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let shift = shift {
            titleField.text = shift.title
            descriptionField.text = shift.description
            assigneeButton.setTitle("\(shift.user.firstName) \(shift.user.lastName)", for: .normal)
            setDateTitleFor(button: startButton, date: shift.shiftStart)
            setDateTitleFor(button: endButton, date: shift.shiftFinish)
            let formatter = DateFormatter()
            formatter.dateFormat = K.dateFormats.serverFormatNoMs
            shiftStart = formatter.date(from: shift.shiftStart)
            shiftEnd = formatter.date(from: shift.shiftFinish)
        }
    }
    
    func setDateTitleFor(button: UIButton, date: Date) {
        button.setTitle(date.changeDateFormat(to: K.dateFormats.userDateTime), for: .normal)
    }
    
    func setDateTitleFor(button: UIButton, date: String) {
        button.setTitle(date.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.userDateTime), for: .normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func assigneeButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func timeButtonPressed(_ sender: UIButton) {
        let title = { () -> String in
            switch sender.tag {
            case 1: return "Select end time"
            default: return "Select start time"
            }
        }()
        let currentSelectedDate = { () -> Date? in
            switch sender.tag {
            case 1: return shiftEnd
            default: return shiftStart
            }
        }()
        var minDate: Date?
        if sender.tag == 1 { minDate = shiftStart }
        DatePickerDialog().show(title, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: currentSelectedDate ?? Date(), minimumDate: minDate, datePickerMode: .dateAndTime) { date in
                if let dt = date {
                    if sender.tag == 1 {
                        self.shiftEnd = dt
                    } else {
                        self.shiftStart = dt
                    }
                    sender.setTitle(dt.changeDateFormat(to: K.dateFormats.userDateTime), for: .normal)
                }
            }
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if let shiftEnd = shiftEnd,
        let shiftStart = shiftStart,
        let shift = shift {
            if shiftEnd < shiftStart {
                let alert = UIAlertController(title: "Invalid dates", message: "Shift end can not be earlier than shift start. Please, change the date.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            var assigneeId = shift.user.id
            if let userId = userId {
                assigneeId = userId
            }
            
            let requestURL = "\(K.baseURL)\(K.Endpoints.shiftRequest)"
            let updateShiftParameters = UpdateShiftModel(shiftId: shift.id, userId: assigneeId, title: titleField.text!, description: descriptionField.text!, shiftStart: shiftStart.changeDateFormat(to: K.dateFormats.serverFormatNoMs), shiftFinish: shiftEnd.changeDateFormat(to: K.dateFormats.serverFormatNoMs))
            let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
            
            AF.request(requestURL, method: .put, parameters: updateShiftParameters, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        print("Shift changed")
                        self.dismiss(animated: true)
                    case let .failure(error) :
                        print(error)
                    }
                }
            
        }
    }
}
