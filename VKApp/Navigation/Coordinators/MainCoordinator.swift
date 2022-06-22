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
            title: NSLocalizedString("Feed", comment: ""),
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )
    }
    
}