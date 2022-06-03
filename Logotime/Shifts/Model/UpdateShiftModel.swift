//
//  UpdateShiftModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 03.06.2022.
//

import Foundation

struct UpdateShiftModel: Encodable {
    var shiftId: UUID
    var userId: UUID
    var title: String
    var description: String
    var shiftStart: String
    var shiftFinish: String
}
