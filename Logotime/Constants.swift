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
    }
    struct Segues {
        static let userCreationToOrganisationCreation = "userToOrganisationRegistration"
        static let organisationCreationToRuleCreation = "organisationToRuleRegistration"
        static let registrationToCreationToMain = "registrationToMain"
        static let loginToMain = "loginToMain"
        static let menuToUsers = "menuToUsers"
        static let userListToDetail = "userListToDetail"
        static let detailsToEditUser = "detailsToEditUser"
    }
    struct Colors {
        static let primaryColor = "PrimaryColor"
        static let secondaryColor = "Color"
    }
    struct VC {
        static let loginNavVC = "loginNavigationController"
        static let mainTabVC = "mainTabBarController"
    }
    struct reusableCells {
        static let userCell = "organisationUserCell"
        static let userCellNibName = "UserTableViewCell"
        static let menuHeaderCell = "menuHeaderCell"
        static let menuItemCell = "menuItemCell"
        static let logoutCell = "logoutCell"
        struct UserDetailsTable {
            static let userDetailsNameCell = "userDetailsNameCell"
            static let userDetailsPhoneCell = "userDetailsPhoneCell"
            static let userDetailsCell = "userDetailsCell"
        }
    }
}
