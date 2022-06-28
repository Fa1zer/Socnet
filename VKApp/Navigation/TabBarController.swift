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
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coordinatorDelegate: RegistrationCoordinator?
    private let dataManager: DataManager
    
    private var mainCoordinator: MainCoordinator { MainCoordinator(dataManager: self.dataManager) }
    private var profileCoordinator: ProfileCoordnator { ProfileCoordnator(dataManager: self.dataManager) }
    private var savedCoordinator: SavedCoordnator { SavedCoordnator(dataManager: self.dataManager) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationControllers()
        self.setupViews()
    }
    
    func goToOnboarding() {
        self.coordinatorDelegate?.goToOnboarding()
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
