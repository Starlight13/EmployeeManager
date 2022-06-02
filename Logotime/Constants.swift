//
//  Constants.swift
//  Logotime
//
//  Created by dsadas asdasd on 16.05.2022.
//

import Foundation

struct K {
    static var baseURL = "http://localhost:8080"
    struct Endpoints {
        static let organisationRequest = "/organization"
        static let userRequest = "/user"
        static let shiftRequest = "/shift"
    }
    struct Segues {
        static let userCreationToOrganisationCreation = "userToOrganisationRegistration"
        static let organisationCreationToRuleCreation = "organisationToRuleRegistration"
        static let registrationToCreationToMain = "registrationToMain"
        static let loginToMain = "loginToMain"
        static let menuToUsers = "menuToUsers"
        static let userListToDetail = "userListToDetail"
        static let detailsToEditUser = "detailsToEditUser"
        static let addShiftToAssign = "addShiftToAssign"
        static let assignShiftToDetails = "assignShiftToDetails"
    }
    struct Colors {
        static let primaryColor = "PrimaryColor"
        static let secondaryColor = "Color"
    }
    struct VC {
        static let loginNavVC = "loginNavigationController"
        static let mainTabVC = "mainTabBarController"
        static let addShiftNavVC = "addShiftNavigationController"
    }
    struct reusableCells {
        static let userCell = "organisationUserCell"
        static let userCellNibName = "UserTableViewCell"
        static let menuHeaderCell = "menuHeaderCell"
        static let menuItemCell = "menuItemCell"
        static let logoutCell = "logoutCell"
        struct ShiftsTable {
            static let shiftCell = "shiftCell"
            static let shiftCellNibName = "ShiftTableViewCell"
        }
        struct UserDetailsTable {
            static let userDetailsNameCell = "userDetailsNameCell"
            static let userDetailsPhoneCell = "userDetailsPhoneCell"
            static let userDetailsCell = "userDetailsCell"
        }
        struct AssignShift {
            static let assignShiftCell = "assignShiftCell"
        }
    }
}
