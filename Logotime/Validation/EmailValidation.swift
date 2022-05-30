//
//  EmailValidation.swift
//  Logotime
//
//  Created by dsadas asdasd on 30.05.2022.
//

import Foundation

struct EmailValidation {
    static func isValid(_ email: String) -> Bool{
        let emailRecipientRegEx = "^[a-zA-Z0-9]([a-zA-Z0-9][_!#$%&\"’*+/=?`{|}~^.\\-]?)+[a-zA-Z0-9]$"
        let emailDomainRegEx = "^[a-zA-Z0-9]{2,}(\\.[a-zA-Z0-9]{2,})?\\.[a-z]{2,}$"
        
        let emailParts = email.components(separatedBy: CharacterSet(charactersIn: "@"))
        if emailParts.count != 2 {
            return false
        }
    
        let emailPredForRecipient = NSPredicate(format:"SELF MATCHES %@", emailRecipientRegEx)
        let emailPredForDomain = NSPredicate(format:"SELF MATCHES %@", emailDomainRegEx)
        return emailPredForRecipient.evaluate(with: emailParts[0]) && emailPredForDomain.evaluate(with: emailParts[1])
    }
}
