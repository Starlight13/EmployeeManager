//
//  OrganisationModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 02.06.2022.
//

import Foundation

struct OrganisationModel: Codable {
    var id: String
    var name: String
    var organizationSize: OrganisationSize
    var rules: OrganisationRulesModel
}
