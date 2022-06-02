//
//  Date.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import Foundation

extension Date {
    var startOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 1
        guard let monday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: monday)
    }

    var endOfWeek: Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.firstWeekday = 1
        guard let monday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: monday)
    }
    
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}

        return localDate
    }
    
    func changeDateFormat(to format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func changeDateFormat(fromFormat: String, toFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        let date = formatter.date(from: self)

        formatter.dateFormat = toFormat
        return formatter.string(from: date ?? Date())
    }
}
