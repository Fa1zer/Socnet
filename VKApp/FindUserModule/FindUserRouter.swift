//
//  FindUserRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 13.07.2022.
//

import Foundation

final class FindUserRouter: ProfileCoordnatable {
    
    var coordinatorDelegate: ProfileCoordnator?
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.coordinatorDelegate?.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }

}
