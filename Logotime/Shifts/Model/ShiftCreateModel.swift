//
//  ShiftCreateModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import Foundation

struct ShiftCreateModel: Encodable {
    var userIds: [UUID]
    var title: String
    var description: String
    var shifts: [ShiftTimeModel]
}
