//
//  OnboardingInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 28.06.2022.
//

import Foundation

final class OnboardingInteractor {
    
    init(dataManager: DataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager) {
        self.dataManager = dataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
    }
    
    private let dataManager: DataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    
    func signIn(didComplete: @escaping () -> Void) {
        guard let (email, password) = self.getKeychainData() else {
            return
        }
        
        self.registrationManager.signIn(email: email, password: password, didNotComplete: { _ in }, didComplete: didComplete)
    }
    
    private func getKeychainData() -> (String, String)? {
        return self.keychainManager.getKeychainData()
    }
    
}
