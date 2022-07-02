//
//  OnboardingPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 28.06.2022.
//

import Foundation

final class OnboardingPresenter {
    
    init(interactor: OnboardingInteractor, router: OnboardingRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private let interactor: OnboardingInteractor
    private let router: OnboardingRouter
    
    func signIn(didComplete: @escaping () -> Void) {
        self.interactor.signIn(didComplete: didComplete)
    }
    
    func goToTabBar() {
        self.router.goToTabBar()
    }
    
    func goToLogIn() {
        self.router.goToLogIn()
    }
    
    func goToSignIn() {
        self.router.goToSignIn()
    }
    
}
