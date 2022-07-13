//
//  CommentsRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import Foundation

final class CommentsRouter: ProfileCoordnatable {
    
    var coordinatorDelegate: ProfileCoordnator?
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.coordinatorDelegate?.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
}
