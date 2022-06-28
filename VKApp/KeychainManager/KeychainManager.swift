//
//  KeychainManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 28.06.2022.
//

import Foundation
import KeychainAccess

final class KeychainManager {
    
    private let keychain = Keychain()
    
    func keychainSave(email: String, password: String) {
        self.keychain[KeychainKeys.email.rawValue] = email
        self.keychain[KeychainKeys.password.rawValue] = password
    }
    
    func getKeychainData() -> (String, String)? {
        guard let email = self.keychain[KeychainKeys.email.rawValue],
              let password = self.keychain[KeychainKeys.password.rawValue] else {
            print("❌ Error: keychain items are equal nil.")
            
            return nil
        }
        
        return (email, password)
    }
    
    func deleteKeychainData() {
        self.keychain[KeychainKeys.email.rawValue] = nil
        self.keychain[KeychainKeys.password.rawValue] = nil
    }
    
    private enum KeychainKeys: String {
        case email, password
    }
    
}
