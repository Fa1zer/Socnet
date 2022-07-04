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
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
        
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController?
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    
    let navigationController = UINavigationController()
    
    func start() {
        
    }
    
    func goToOnboarding() {
        self.tabBarDelegate?.goToOnboarding()
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person")
        )
    }
    
}
