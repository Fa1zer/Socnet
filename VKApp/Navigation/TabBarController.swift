//
//  TabBarController.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import UIKit

protocol TabBarCoordinatable {
    
    var tabBarDelegate: TabBarController? { get set }
    
    func start()
    
}

final class TabBarController: UITabBarController, RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    private let mainCoordinator = MainCoordinator()
    private let profileCoordinator = ProfileCoordnator()
    private let savedCoordinator = SavedCoordnator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationControllers()
        self.setupViews()
    }
    
    private func setupNavigationControllers() {
        self.mainCoordinator.tabBarDelegate = self
        self.profileCoordinator.tabBarDelegate = self
        self.savedCoordinator.tabBarDelegate = self
        
        let navigationControllers = [
            self.mainCoordinator.navigationController,
            self.profileCoordinator.navigationController,
            self.savedCoordinator.navigationController
        ]
        
        self.viewControllers = navigationControllers
    }
    
    private func setupViews() {
        self.tabBar.tintColor = .systemOrange
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

}
