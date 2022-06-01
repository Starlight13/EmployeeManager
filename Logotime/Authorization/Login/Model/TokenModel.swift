//
//  TokenModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 30.05.2022.
//

import Foundation
import SwiftKeychainWrapper
import JWTDecode

final class Token {
    private enum Keys: String{
        case token
    }
    
    
    static var token: String? {
        get{
            return KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set{
            guard let token = newValue?.components(separatedBy: " ")[1] else { KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue); return}
            KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
        }
    }
    
//body: ["jti": 228ac3c4-9145-48c7-a012-a6670e330062, "firstName": Qwrwe, "organizationId": 6f6b0c1e-190c-4973-93bb-16482df15df0, "email": qwerty13@gmail.com, "userId": 228ac3c4-9145-48c7-a012-a6670e330062, "lastName": Qwerty, "role": OWNER, "iat": 1654086363, "exp": 1654098363]
    
    static var tokenBody: [String : Any] {
        get {
            do {
                let jwt = try decode(jwt: Token.token ?? "")
                return jwt.body
            } catch {
                print(error)
                (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate).logout()
            }
            return [:]
        }
    }
}
