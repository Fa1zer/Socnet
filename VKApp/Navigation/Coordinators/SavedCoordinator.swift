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
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        self.setupViews()
        self.start()
    }
    
    var tabBarDelegate: TabBarController?
    private let dataManager: DataManager
        
    let navigationController = UINavigationController()
    
    func start() {
        
    }
    
    private func setupViews() {
        self.navigationController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Saved", comment: ""),
            image: UIImage(systemName: "archivebox"),
            selectedImage: UIImage(systemName: "archivebox")
        )
    }
    
}
