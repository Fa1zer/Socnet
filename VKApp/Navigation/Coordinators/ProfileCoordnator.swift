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
    
    init() {
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController?
    let navigationController = UINavigationController()
    
    func start() {
        
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Profile", comment: ""),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person")
        )
    }
    
}
