//
//  LogInCoordinator.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 22.06.2022.
//

import Foundation
import UIKit

protocol RegistrationCoordinatable {
    var coordinatorDelegate: RegistrationCoordinator? { get set }
}

final class RegistrationCoordinator {
    
    init() {
        self.setupViews()
        self.start()
    }
    
    let navigationController = UINavigationController()
    private let dataManager = DataManager()
    
    func start() {
        self.goToTabBar()
    }
    
    private func setupViews() {
        self.navigationController.navigationBar.isHidden = true
    }
    
    private func goToTabBar() {
        let tabBarController = TabBarController(dataManager: self.dataManager)
        
        tabBarController.coordinatorDelegate = self
        
        self.navigationController.pushViewController(tabBarController, animated: true)
    }
    
}

