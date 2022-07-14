//
//  ProfileRouter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import Foundation
import UIKit

final class ProfileRouter: ProfileCoordnatable {    
    
    var coordinatorDelegate: ProfileCoordnator?
    
    func goToEdit() {
        self.coordinatorDelegate?.goToLogOut()
    }
    
    func goToCreatePost(userID: UUID) {
        self.coordinatorDelegate?.goToCreatePost(userID: userID)
    }
    
    func goToComments(likeAction: @escaping (Post, User) -> Void, dislikeAction: @escaping (Post, User) -> Void, commentAction: @escaping (PostTableViewCell) -> Void, avatarAction: @escaping (User) -> Void, post: Post, user: User, likeButtonIsSelected: Bool, frame: CGRect) {
        self.coordinatorDelegate?.goToComments(likeAction: likeAction, dislikeAction: dislikeAction, commentAction: commentAction, avatarAction: avatarAction, post: post, user: user, likeButtonIsSelected: likeButtonIsSelected, frame: frame)
    }
    
    func goToFindUser(userID: UUID, mode: FindUserMode) {
        self.coordinatorDelegate?.goToFindUser(userID: userID, mode: mode)
    }
    
}
