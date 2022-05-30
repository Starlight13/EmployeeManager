//
//  UserRole.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import Foundation

enum UserRole: String, Encodable {
    case owner = "OWNER"
    case admin = "ADMINISTRATOR"
    case employee = "EMPLOYEE"
}
