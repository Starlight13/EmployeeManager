//
//  CreateUserModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import Foundation

struct CreateUserRequest: Codable {
    var lastName: String
    var firstName: String
    var email: String
    var password: String
    var phoneNumber: String
    var userRole: UserRole
}
