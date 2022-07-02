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
    private var registrationManager: RegistrationManager { RegistrationManager(dataManager: self.dataManager) }
    
    func start() {
        self.goToOnboarding()
    }
    
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
    }
    
    func goToRegistration(registrationMode: RegistrationMode) {
        let router = RegistrationRouter()
        let interactor = RegistrationInteractor(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager)
        let presenter = RegistrationPresenter(interactor: interactor, router: router, registrationMode: registrationMode)
        let viewController = RegistrationViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToOnboarding() {
        let router = OnboardingRouter()
        let interactor = OnboardingInteractor(dataManager: self.dataManager, registrationManager: self.registrationManager, keychainManager: self.keychainManager)
        let presenter = OnboardingPresenter(interactor: interactor, router: router)
        let viewController = OnboardingViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToTabBar() {
        let tabBarController = TabBarController(dataManager: self.dataManager)
        
        tabBarController.coordinatorDelegate = self
        
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
}

