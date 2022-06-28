//
//  RegistrationInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation

final class RegistrationInteractor {
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.registrationManager = RegistrationManager(dataManager: self.dataManager)
    }
    
    private let dataManager: DataManager
    private let registrationManager: RegistrationManager
    
    func logIn(email: String, password: String, didNotComplete: @escaping (LogInErrors) -> Void, didComplete: @escaping () -> Void) {
        self.registrationManager.logIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func signIn(email: String, password: String, didNotComplete: @escaping (SignInErrors) -> Void, didComplete: @escaping () -> Void) {
        self.registrationManager.signIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
