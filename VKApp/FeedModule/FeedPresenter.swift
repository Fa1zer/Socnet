//
//  FeedPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 05.07.2022.
//

import Foundation
import UIKit

final class FeedPresenter {
    
    init(router: FeedRouter, interactor: FeedInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    var callBack: (() -> Void)?
    
    private let router: FeedRouter
    private let interactor: FeedInteractor
    private(set) var posts = [(post: Post, user: User)]() {
        didSet {
            self.callBack?()
        }
    }
    
    func save(post: Post, user: User) {
        self.interactor.save(post: post, user: user)
    }
    
    func getAllPosts(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void = { }) {
        self.interactor.getAllPost(didNotComplete: didNotComplete) { posts in
            DispatchQueue.main.async { [ weak self ] in
                for post in posts {
                    self?.getUser(userID: post.userID, didNotComplete: { _ in }) { user in
                        let newPost = (post: post, user: user)
                        
                        if !(self?.posts.contains { $0.post.id == newPost.post.id } ?? true) {
                            self?.posts.append(newPost)
                        }
                    }
                }
                
                self?.callBack?()
                
                didComplete()
            }
        }
    }
    
    func getAllCoreDataPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.interactor.getAllCoreDataPosts(didComplete: didComplete)
    }
    
    func getAllCoreDataUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        self.interactor.getAllCoreDataUsers(didComplete: didComplete)
    }
    
    func like(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.like(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    private func getUser(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.interactor.getSomeUser(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func deletePost(post: Post) {
        self.interactor.deletePost(post: post)
    }
    
    func goToProfile(userID: UUID?, isSubscribedUser: Bool) {
        self.router.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
}
