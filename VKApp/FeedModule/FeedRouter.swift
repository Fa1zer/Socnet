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
    
    func goToComments(likeAction: @escaping (Post, User) -> Void, dislikeAction: @escaping (Post, User) -> Void, commentAction: @escaping (PostTableViewCell) -> Void, avatarAction: @escaping (User) -> Void, post: Post, user: User, likeButtonIsSelected: Bool, frame: CGRect) {
        self.coordinatorDelegate?.goToComments(likeAction: likeAction, dislikeAction: dislikeAction, commentAction: commentAction, avatarAction: avatarAction, post: post, user: user, likeButtonIsSelected: likeButtonIsSelected, frame: frame)
    }
    
}
