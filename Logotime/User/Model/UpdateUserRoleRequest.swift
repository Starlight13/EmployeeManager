//
//  changeUserRoleRequest.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import Foundation

struct UpdateUserRoleRequest: Codable {
    var userId: UUID
    var userRole: UserRole
}
