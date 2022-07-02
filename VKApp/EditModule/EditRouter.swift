//
//  EditRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import Foundation

final class EditRouter: RegistrationCoordinatable {
    
    var coordinatorDelegate: RegistrationCoordinator?
    
    func goToTabBar() {
        self.coordinatorDelegate?.goToTabBar()
    }
    
}
