//
//  ShiftModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import Foundation

struct ShiftModel: Decodable {
    var id: UUID
    var title: String
    var description: String
    var shiftStart: String
    var shiftFinish: String
    var user: User

    var tasks: [TaskModel]
}
