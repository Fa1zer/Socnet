//
//  ProfileRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import Foundation

final class ProfileRouter: ProfileCoordnatable {
    
    var coordinatorDelegate: ProfileCoordnator?
    
    func goToEdit() {
        self.coordinatorDelegate?.goToLogOut()
    }
    
}
