//
//  ProfileCoordnator.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import Foundation
import UIKit

protocol ProfileCoordnatable {
    var coordinatorDelegate: ProfileCoordnator? { get set }
}

final class ProfileCoordnator: TabBarCoordinatable {    
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager, tabBarDelegate: TabBarController) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
        self.tabBarDelegate = tabBarDelegate
        
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    
    let navigationController = UINavigationController()
    
    func start() {
        self.goToProfile()
    }
    
    func goToOnboarding() {
        self.tabBarDelegate.goToOnboarding()
    }
    
    func goToLogOut() {
        print(self.tabBarDelegate)
        
        self.tabBarDelegate.goToLogOut()
    }
    
    func goToProfile() {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager)
        let presenter = ProfilePresenter(router: router, interactor: interactor, isAlienUser: false)
        let viewController = ProfileViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToCreatePost(userID: UUID) {
        let router = CreatePostRouter()
        let interactor = CreatePostInteractor(dataManager: self.dataManager)
        let presenter = CreatePostPresenter(interactor: interactor, router: router, userID: userID)
        let viewController = CreatePostViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person")
        )
        self.navigationController.navigationBar.backgroundColor = .backgroundColor
        self.navigationController.navigationBar.alpha = 0.8
    }
    
}
