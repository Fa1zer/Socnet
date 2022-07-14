//
//  LogInCoordinator.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import Foundation
import UIKit

protocol RegistrationCoordinatable {
    var coordinatorDelegate: RegistrationCoordinator? { get set }
}

final class RegistrationCoordinator {
    
    init() {
        self.setupViews()
        self.start()
    }
    
    let navigationController = UINavigationController()
    private let dataManager = DataManager()
    private let keychainManager = KeychainManager()
    private let userDefaultsManager = UserDefaultsManager()
    private var registrationManager: RegistrationManager { RegistrationManager(dataManager: self.dataManager) }
    
    func start() {
        guard let (email, password) = self.keychainManager.getKeychainData() else {
            self.goToOnboarding()

            return
        }
        
        guard self.userDefaultsManager.getUserData() != nil else {
            goToOnboarding()
            
            return
        }

        self.registrationManager.signIn(email: email, password: password) { _ in
            self.goToOnboarding()
        } didComplete: {
            self.goToTabBar()
        }
    }
    
    func goToRegistration(registrationMode: RegistrationMode) {
        let router = RegistrationRouter()
        let interactor = RegistrationInteractor(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager, userDefaultsManager: self.userDefaultsManager)
        let presenter = RegistrationPresenter(interactor: interactor, router: router, registrationMode: registrationMode)
        let viewController = RegistrationViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToOnboarding() {
        let router = OnboardingRouter()
        let interactor = OnboardingInteractor()
        let presenter = OnboardingPresenter(interactor: interactor, router: router)
        let viewController = OnboardingViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToLogOut() {
        let router = EditRouter()
        let interactor = EditInteractor(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager)
        let presenter = EditPresenter(interactor: interactor, router: router, isFirstEdit: false)
        let viewController = EditViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToTabBar() {
        let tabBarController = TabBarController(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager, userDefaultsManager: self.userDefaultsManager)
        
        tabBarController.coordinatorDelegate = self
        
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func goToEdit() {
        let router = EditRouter()
        let interactor = EditInteractor(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager)
        let presenter = EditPresenter(interactor: interactor, router: router, isFirstEdit: true)
        let viewController = EditViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
    }
    
}
