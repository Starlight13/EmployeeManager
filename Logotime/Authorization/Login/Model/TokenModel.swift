//
//  TokenModel.swift
//  Logotime
//
//  Created by dsadas asdasd on 30.05.2022.
//

import Foundation
import SwiftKeychainWrapper

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
}
