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
        static let organisationUserCell = "organisationUserCell"
    }
}
