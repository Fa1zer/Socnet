//
//  CommentsPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import Foundation
import UIKit

final class CommentsPresenter {
    
    init(interactor: CommentsInteractor, router: CommentsRouter, likeAction: @escaping (Post, User) -> Void, dislikeAction: @escaping (Post, User) -> Void, commentAction: @escaping (PostTableViewCell) -> Void, avatarAction: @escaping (User) -> Void, post: Post, user: User, likeButtonIsSelected: Bool, frame: CGRect) {
        self.interactor = interactor
        self.router = router
        self.likeAction = likeAction
        self.dislikeAction = dislikeAction
        self.commentAction = commentAction
        self.avatarAction = avatarAction
        self.post = post
        self.user = user
        self.likeButtonIsSelected = likeButtonIsSelected
        self.frame = frame
    }
    
    var callBack: (() -> Void)?
    let likeAction: (Post, User) -> Void
    let dislikeAction: (Post, User) -> Void
    let commentAction: (PostTableViewCell) -> Void
    let avatarAction: (User) -> Void
    let post: Post
    let user: User
    let likeButtonIsSelected: Bool
    let frame: CGRect
    private let interactor: CommentsInteractor
    private let router: CommentsRouter
    
    var comments = [(comment: Comment, user: User)]() {
        didSet {
            self.callBack?()
        }
    }
    
    func getComments(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interactor.getComments(postID: postID, didNotComplete: didNotComplete) { [ weak self ] comments in
            for comment in comments {
                guard let id = comment.id else {
                    return
                }
                
                self?.getUser(commentID: id, didNotComplete: didNotComplete) { user in
                    self?.comments.append((comment: comment, user: user))
                }
            }
            
            self?.callBack?()
        }
    }
    
    func getUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        self.interactor.getUsers(didComplete: didComplete)
    }
    
    func createComment(comment: Comment, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.createComment(comment: comment, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func geToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.router.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
    func getUserData() -> (image: String, name: String, id: String)? {
        self.interactor.getUserData()
    }
    
    private func getUser(commentID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.interactor.getUser(commentID: commentID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
