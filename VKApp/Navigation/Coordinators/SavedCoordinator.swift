//
//  SaveCoordinator.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import Foundation
import UIKit

protocol SavedCoordnatable {
    var coordinatorDelegate: SavedCoordnator? { get set }
}

final class SavedCoordnator: TabBarCoordinatable {
    
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
        self.goToSaved()
    }
    
    func goToSaved() {
        let router = SavedRouter()
        let interacotr = SavedInteractor(coreDataManager: self.coreDataManager, dataManager: self.dataManager)
        let presenter = SavedPresenter(router: router, interactor: interacotr)
        let viewController = SavedViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.coreDataManager.tableView = viewController.tableView
        self.coreDataManager.callBack = presenter.getPosts
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
            title: NSLocalizedString("Saved", comment: ""),
            image: UIImage(systemName: "archivebox"),
            selectedImage: UIImage(systemName: "archivebox")
        )
        self.navigationController.navigationBar.backgroundColor = .backgroundColor
        self.navigationController.navigationBar.alpha = 0.8
    }
    
}
