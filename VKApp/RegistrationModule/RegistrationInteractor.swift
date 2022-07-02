//
//  RegistrationInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation
import KeychainAccess

final class RegistrationInteractor {
    
    init(dataManager: DataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager) {
        self.dataManager = dataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
    }
    
    private let dataManager: DataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    
    private let keychain = Keychain()
    
    func logIn(email: String, password: String, didNotComplete: @escaping (LogInErrors) -> Void, didComplete: @escaping () -> Void) {
        let newDidComplete = {
            didComplete()
            self.keycahinSave(email: email, password: password)
        }
        
        self.registrationManager.logIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: newDidComplete)
    }
    
    func signIn(email: String, password: String, didNotComplete: @escaping (SignInErrors) -> Void, didComplete: @escaping () -> Void) {
        self.registrationManager.signIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    private func keycahinSave(email: String, password: String) {
        self.keychainManager.keychainSave(email: email, password: password)
    }
    
}
