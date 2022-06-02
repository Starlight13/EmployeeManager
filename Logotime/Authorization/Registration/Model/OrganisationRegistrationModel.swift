//
//  OrganisationRegistrationModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 21.05.2022.
//

import Foundation

struct OrganisationRegistrationModel: Encodable {
    let name: String
    let organizationSize: OrganisationSize
    let user: OwnerCreationModel
    let rules: OrganisationRulesModel
    let maxEmployeeShiftApplication: Int?
}
