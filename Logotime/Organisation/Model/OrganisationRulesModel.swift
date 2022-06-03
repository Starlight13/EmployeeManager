//
//  RuleCreationModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 21.05.2022.
//

import Foundation

struct OrganisationRulesModel: Codable {
    let substituteMeRule: SubstituteMeRule
    let swapShiftRule: SwapShiftRule
    let checkInRule: CheckInRule
    let notAssignedShiftRule: NotAssignedShiftRule
    let maxEmployeeShiftApplication: Int?
}

enum SubstituteMeRule: String, Codable {
    case prohibited = "PROHIBITED"
    case needsApproval = "ALLOW_NEED_APPROVE"
    case allowed = "ALLOW_WITHOUT_APPROVE"
}

enum SwapShiftRule: String, Codable {
    case prohibited = "PROHIBITED"
    case needsApproval = "ALLOW_NEED_APPROVE"
    case allowed = "ALLOW_WITHOUT_APPROVE"
}

enum CheckInRule: String, Codable {
    case button = "BUTTON"
    case geo = "BUTTON_GEOLOCATION"
    case photo = "BUTTON_PHOTO"
    case all = "BUTTON_GEOLOCATION_PHOTO"
}

enum NotAssignedShiftRule: String, Codable {
    case prohibited = "PROHIBITED"
    case allowed = "ALLOWED"
}
