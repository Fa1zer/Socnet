//
//  CreatePostRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 11.07.2022.
//

import Foundation

final class CreatePostRouter: ProfileCoordnatable {
    
    var coordinatorDelegate: ProfileCoordnator?
     
    func goToProfile() {
        self.coordinatorDelegate?.goToProfile()
    }
    
}
