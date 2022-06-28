//
//  RegistartionPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation

final class RegistrationPresenter {
    
    init(interactor: RegistrationInteractor, router: RegistrationRouter, registrationMode: RegistrationMode) {
        self.interactor = interactor
        self.router = router
        self.registrationMode = registrationMode
    }
    
    let registrationMode: RegistrationMode
    private let interactor: RegistrationInteractor
    private let router: RegistrationRouter
    
    func logIn(email: String, password: String, didNotComplete: @escaping (LogInErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.logIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func signIn(email: String, password: String, didNotComplete: @escaping (SignInErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.signIn(email: email, password: password, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func goToTabBar() {
        self.router.goToTabBar()
    }
    
}
