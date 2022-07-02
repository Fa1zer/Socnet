//
//  OnboardingRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 28.06.2022.
//

import Foundation

final class OnboardingRouter: RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    func goToTabBar() {
        self.coordinatorDelegate?.goToTabBar()
    }
    
    func goToLogIn() {
        self.coordinatorDelegate?.goToRegistration(registrationMode: .logIn)
    }
    
    func goToSignIn() {
        self.coordinatorDelegate?.goToRegistration(registrationMode: .sigIn)
    }
    
}
