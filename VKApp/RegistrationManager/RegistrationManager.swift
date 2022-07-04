//
//  RegistrationManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation

final class RegistrationManager {
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    private let dataManager: DataManager
    
    func logIn(email: String, password: String, didNotComplete: @escaping (LogInErrors) -> Void, didComplete: @escaping () -> Void) {
        guard email.isValidEmail else {
            didNotComplete(.emailNotFound)
            
            return
        }
        
        guard password.count >= 8 else {
            didNotComplete(.passwordTooShort)
            
            return
        }
        
        self.dataManager.postUser(user: User(email: email, passwordHash: password), didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func signIn(email: String, password: String, didNotComplete: @escaping (SignInErrors) -> Void, didComplete: @escaping () -> Void) {
        guard email.isValidEmail else {
            didNotComplete(.emailNotFound)
            
            return
        }
        
        guard password.count >= 8 else {
            didNotComplete(.passwordTooShort)
            
            return
        }
        
        self.dataManager.auth(email: email, password: password, didComplete: didComplete, didNotComplete: didNotComplete)
    }
        
    func logOut(didComplete: @escaping () -> Void, didNotComplete: @escaping (SignInErrors) -> Void) {
        self.dataManager.logOut(didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: self)
    }
}
