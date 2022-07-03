//
//  RegistrationRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 27.06.2022.
//

import Foundation

final class RegistrationRouter: RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    func goToTabBar() {
        self.coordinatorDelegate?.goToTabBar()
    }
    
    func goToEdit() {
        self.coordinatorDelegate?.goToEdit()
    }
    
}
