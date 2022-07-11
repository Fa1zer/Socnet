//
//  SavedRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import Foundation

final class SavedRouter: SavedCoordnatable {
    
    var coordinatorDelegate: SavedCoordnator?
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.coordinatorDelegate?.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
}
