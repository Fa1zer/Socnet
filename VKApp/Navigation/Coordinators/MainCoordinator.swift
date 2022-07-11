//
//  MainCoordinator.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import Foundation
import UIKit

protocol MainCoordinatable {
    var coordinatorDelegate: MainCoordinator? { get set }
}

final class MainCoordinator: TabBarCoordinatable {
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager, tabBarDelegate: TabBarController) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
        self.tabBarDelegate = tabBarDelegate
        
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    
    let navigationController = UINavigationController()
    
    func start() {
        self.goToFeed()
    }
    
    func goToFeed() {
        let router = FeedRouter()
        let interactor = FeedInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager)
        let presenter = FeedPresenter(router: router, interactor: interactor)
        let viewController = FeedViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager)
        let presenter = ProfilePresenter(router: router, interactor: interactor, isAlienUser: true, isSubscribedUser: isSubscribedUser, userID: userID)
        let viewController = ProfileViewController(presenter: presenter)
        
        router.coordinatorDelegate = ProfileCoordnator(dataManager: self.dataManager, coreDataManager: self.coreDataManager, registrationManager: RegistrationManager(dataManager: self.dataManager), keychainManager: KeychainManager(), tabBarDelegate: self.tabBarDelegate)
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Feed", comment: ""),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )
        self.navigationController.navigationBar.backgroundColor = .backgroundColor
        self.navigationController.navigationBar.alpha = 0.8
    }
    
}
