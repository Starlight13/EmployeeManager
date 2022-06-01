//
//  OrganisationUser.swift
//  Logotime
//
//  Created by dsadas asdasd on 31.05.2022.
//

import Foundation

struct OrganisationUser: Codable {
    var id: String
    var lastName: String
    var firstName: String
    var email: String
    var phoneNumber: String
    var userRole: UserRole
    var active: Bool
    var creationDate: String
}
