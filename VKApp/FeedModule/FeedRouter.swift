//
//  FeedRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 05.07.2022.
//

import Foundation
import UIKit

final class FeedRouter: MainCoordinatable {
    
    var coordinatorDelegate: MainCoordinator?
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.coordinatorDelegate?.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
}
