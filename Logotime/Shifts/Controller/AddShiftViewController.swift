//
//  AddShiftViewController.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import UIKit
import Koyomi
import DatePickerDialog

class AddShiftViewController: UIViewController {

    var dates = Set<Date>()
    var startTime = Date()
    var endTime = Date()
    var shiftTimes = [ShiftTimeModel]()
    
    @IBOutlet fileprivate weak var koyomi: Koyomi! {
        didSet {
            koyomi.circularViewDiameter = 0.7
            koyomi.calendarDelegate = self
            koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            koyomi.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
            koyomi.style = .standard
            koyomi.dayPosition = .center
            koyomi.selectionMode = .multiple(style: .circle)
            koyomi.selectedStyleColor = UIColor(named: K.Colors.secondaryColor)!
            koyomi
                .setDayFont(fontName: ".SFUIDisplay-Light", size: 25)
                .setWeekFont(fontName: ".SFUIDisplay-Light", size: 15)
            koyomi.weekColor = .black
            koyomi.holidayColor = (saturday: .gray, sunday: .gray)
            koyomi.layer.cornerRadius = 10
            koyomi.weekCellHeight = 30
        }
    }
    
    @IBOutlet fileprivate weak var currentDateLabel: UILabel!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDateLabel.text = koyomi.currentDateString()
        let currentTime = Date().changeDateFormat(to: K.dateFormats.hourMinuteFormat)
        startTimeButton.setTitle(currentTime, for: .normal)
        endTimeButton.setTitle(currentTime, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.addShiftToAssign {
            let destinationVC = segue.destination as! AssignShiftsViewController
            destinationVC.shiftTimes = shiftTimes
        }
    }
    
    //MARK: - Actions
    
    @IBAction func tappedControl(_ sender: UIButton) {
        let month: MonthType = {
            if sender.tag == 0 {
                return .previous
            } else {
                return .next
            }
        }()
        koyomi.display(in: month)
    }
    
    @IBAction func datePickerPressed(_ sender: UIButton) {
        DatePickerDialog().show("Select time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .time) { date in
                if let dt = date {
                    sender.setTitle(dt.changeDateFormat(to: K.dateFormats.hourMinuteFormat), for: .normal)
                    
                    if sender.tag == 0 {
                        self.startTime = dt
                    } else {
                        self.endTime = dt
                    }
                    self.shiftTimes = []
                }
            }
    }
    
    @IBAction func nextStepPressed(_ sender: UIButton) {
        guard dates.count != 0 else {
            return
        }
        for date in dates {
            let calendar = Calendar.current
            
            let startHour = calendar.component(.hour, from: startTime)
            let startMinute = calendar.component(.minute, from: startTime)
            guard let startDate = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: date) else { return }
            
            var fixedEndDate: Date
            if startTime > endTime || startTime == endTime {
                print("fixedDate")
                fixedEndDate = calendar.date(byAdding: .day, value: 1, to: date) ?? Date()
            } else {
                print("didn't fix")
                fixedEndDate = date
            }
            
            let endHour = calendar.component(.hour, from: endTime)
            let endMinute = calendar.component(.minute, from: endTime)
            guard let endDate = calendar.date(bySettingHour: endHour, minute: endMinute, second: 0, of: fixedEndDate) else { return }
            
            shiftTimes.append(ShiftTimeModel(shiftStart: startDate.changeDateFormat(to: K.dateFormats.serverFormat), shiftFinish: endDate.changeDateFormat(to: K.dateFormats.serverFormat)))
        }
        performSegue(withIdentifier: K.Segues.addShiftToAssign, sender: self)
    }
    
    
}

extension AddShiftViewController: KoyomiDelegate {
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        let theCalendar = Calendar.current
        if let realDate = theCalendar.date(byAdding: .day, value: 1, to: date ?? Date()){
            if dates.contains(realDate) {
                dates.remove(realDate)
            } else {
                dates.insert(realDate)
            }
            print(dates)
        }
    }
    
    
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        currentDateLabel.text = dateString
        koyomi.select(dates: Array(dates).map({ date in
            let calendar = Calendar.current
            if let koyomiDate = calendar.date(byAdding: .day, value: -1, to: date) {
                return koyomiDate
            }
            return Date()
        }))
        koyomi.reloadData()
    }
}
