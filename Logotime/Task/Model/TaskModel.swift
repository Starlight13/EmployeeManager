//
//  TaskModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import Foundation

struct TaskModel: Codable {
    var id: UUID?
    var title: String
    var description: String
    var taskTime: String?
    var shiftId: UUID
}
