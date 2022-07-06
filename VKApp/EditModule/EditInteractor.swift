//
//  EditInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import Foundation

final class EditInteractor {
    
    init(dataManager: DataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager) {
        self.dataManager = dataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
    }
    
    private let dataManager: DataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    
    func editUser(user: User, didComplete: @escaping () -> Void, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.dataManager.putUser(user: user, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func logOut(didComplete: @escaping () -> Void, didNotComplete: @escaping (SignInErrors) -> Void) {
        self.registrationManager.logOut(didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
    func deleteKeychainData() {
        self.keychainManager.deleteKeychainData()
    }
    
    
}
