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
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager, registrationManager: RegistrationManager, keychainManager: KeychainManager, tabBarDelegate: TabBarController, userDefaultsManager: UserDefaultsManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
        self.registrationManager = registrationManager
        self.keychainManager = keychainManager
        self.tabBarDelegate = tabBarDelegate
        self.userDefaultsManager = userDefaultsManager
        
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    private let registrationManager: RegistrationManager
    private let keychainManager: KeychainManager
    private let userDefaultsManager: UserDefaultsManager
    
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
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        let router = ProfileRouter()
        let interactor = ProfileInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager)
        let presenter = ProfilePresenter(router: router, interactor: interactor, isAlienUser: true, isSubscribedUser: isSubscribedUser, userID: userID)
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
    
    func goToComments(likeAction: @escaping (Post, User) -> Void, dislikeAction: @escaping (Post, User) -> Void, commentAction: @escaping (PostTableViewCell) -> Void, avatarAction: @escaping (User) -> Void, post: Post, user: User, likeButtonIsSelected: Bool, frame: CGRect) {
        let router = CommentsRouter()
        let interactor = CommentsInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager, userDefaultsManager: self.userDefaultsManager)
        let presenter = CommentsPresenter(interactor: interactor, router: router, likeAction: likeAction, dislikeAction: dislikeAction, commentAction: commentAction, avatarAction: avatarAction, post: post, user: user, likeButtonIsSelected: likeButtonIsSelected, frame: frame)
        let viewController = CommentsViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToFindUser(userID: UUID, mode: FindUserMode) {
        let router = FindUserRouter()
        let interactor = FindUserInteractor(dataManager: self.dataManager, coreDataManager: self.coreDataManager)
        let presenter = FindUserPresenter(interactor: interactor, router: router, mode: mode, userID: userID)
        let viewController = FindUserViewController(presenter: presenter)
        
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
