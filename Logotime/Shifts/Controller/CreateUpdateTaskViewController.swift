//
//  CreateUpdateTaskViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import UIKit
import Alamofire
import DatePickerDialog

class CreateUpdateTaskViewController: UIViewController {
    
    var task: TaskModel?
    var shift: ShiftModel?
    
    var time: Date?
    var maxTime: Date?
    var minTime: Date?

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task {
            titleField.text = task.title
            descriptionField.text = task.description
            if let time = task.taskTime {
                timeButton.titleLabel?.text = time.changeDateFormat(fromFormat: K.dateFormats.serverFormatNoMs, toFormat: K.dateFormats.hourMinuteFormat)
                let formatter = DateFormatter()
                formatter.dateFormat = K.dateFormats.serverFormatNoMs
                self.time = formatter.date(from: time)
            }
        }
        
        if let shift = shift {
            let formatter = DateFormatter()
            formatter.dateFormat = K.dateFormats.serverFormatNoMs
            maxTime = formatter.date(from: shift.shiftFinish)
            minTime = formatter.date(from: shift.shiftStart)
        }
    }
    
    
    @IBAction func datePickerPressed(_ sender: UIButton) {
        DatePickerDialog().show("Select time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: minTime, maximumDate: maxTime, datePickerMode: .dateAndTime) { date in
                if let dt = date {
                    sender.setTitle(dt.changeDateFormat(to: K.dateFormats.userDateTime), for: .normal)
                    sender.titleLabel?.textColor = .black
                    let calendar = Calendar.current
                    let startHour = calendar.component(.hour, from: dt)
                    let startMinute = calendar.component(.minute, from: dt)
                    if let time = self.time {
                        self.time = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: time)
                        print(self.time)
                    }
                }
            }
    }
    
    @IBAction func actionPressed(_ sender: UIButton) {
        print(task)
        print("Button pressed")
        if let task = task {
            //TODO: Update task
        } else {
            //Create task
            if let shift = shift {
                if !titleField.text!.isEmpty &&
                    !descriptionField.text!.isEmpty {
                    let requestURL = "\(K.baseURL)\(K.Endpoints.taskRequest)"
                    let parameters = TaskModel(id: nil, title: titleField.text!, description: descriptionField.text!, taskTime: time?.changeDateFormat(to: K.dateFormats.serverFormat), shiftId: shift.id)
                    let headers: HTTPHeaders = [.authorization(bearerToken: Token.token ?? "")]
                    
                    AF.request(requestURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
                        .validate()
                        .response { response in
                            switch response.result {
                            case .success :
                                print("Success")
                                self.navigationController?.popViewController(animated: true)
                            case let .failure(error):
                                print(error)
                            }
                        }
                }
            }
        }
    }
    
}
