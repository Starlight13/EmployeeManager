//
//  UpdateUserRequest.swift
//  Logotime
//
//  Created by dsadas asdasd on 01.06.2022.
//

import Foundation

struct UpdateUserRequest: Codable {
    var lastName: String
    var firstName: String
    var email: String
    var phoneNumber: String
}
