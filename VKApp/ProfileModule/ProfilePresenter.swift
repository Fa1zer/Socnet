//
//  ProfilePresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import Foundation
import UIKit

final class ProfilePresenter {
    
    init(router: ProfileRouter, interactor: ProfileInteractor, isAlienUser: Bool, isSubscribedUser: Bool = false, userID: UUID? = nil){
        self.router = router
        self.interactor = interactor
        self.isAlienUser = isAlienUser
        self.isSubscribedUser = isSubscribedUser
        self.userID = userID
    }
    
    var callBack: (() -> Void)?
    
    private let router: ProfileRouter
    private let interactor: ProfileInteractor
    private let userID: UUID?
    let isAlienUser: Bool
    let isSubscribedUser: Bool
    
    var photos: [UIImage] {
        var photos = [UIImage]()
        
        for imageString in self.user?.images ?? [] {
            guard let photo = UIImage(data: Data(base64Encoded: imageString) ?? Data()) else {
                break
            }
            
            photos.append(photo)
        }
        
        return photos
    }
    private(set) var posts = [Post]()
    private(set) var user: User?
    
    func getUser(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void = { }) {
        self.interactor.getUser(didNotComplete: didNotComplete) { [ weak self ] user in
            self?.user = user
            self?.callBack?()
            
            guard let id = user.id else {
                return
            }
            
            self?.getAllUserPosts(userID: id) { error in
                print("❌ Error: \(error.localizedDescription)")
            } didComplete: {
                didComplete()
            }
        }
    }
    
    func getSomeUser(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void = { }) {
        guard let userID = self.userID else {
            return
        }
        
        self.interactor.getSomeUser(userID: userID, didNotComplete: didNotComplete) { [ weak self ] user in
            self?.user = user
            self?.callBack?()
            
            guard let id  = user.id else {
                return
            }
            
            self?.getAllUserPosts(userID: id) { error in
                print("❌ Error: \(error.localizedDescription)")
            } didComplete: {
                didComplete()
            }
        }
    }
    
    func like(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.like(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func save(post: Post, user: User) {
        self.interactor.save(post: post, user: user)
    }
    
    func getAllCoreDataPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.interactor.getAllCoreDataPosts(didComplete: didComplete)
    }
    
    func goToEdit() {
        self.router.goToEdit()
    }
    
    func goToCreatePost() {
        guard let id = self.user?.id else {
            return
        }
        
        self.router.goToCreatePost(userID: id)
    }
    
    func goToComments(likeAction: @escaping (Post, User) -> Void, dislikeAction: @escaping (Post, User) -> Void, commentAction: @escaping (PostTableViewCell) -> Void, avatarAction: @escaping (User) -> Void, post: Post, user: User, likeButtonIsSelected: Bool, frame: CGRect) {
        self.router.goToComments(likeAction: likeAction, dislikeAction: dislikeAction, commentAction: commentAction, avatarAction: avatarAction, post: post, user: user, likeButtonIsSelected: likeButtonIsSelected, frame: frame)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func deletePost(post: Post) {
        self.interactor.deletePost(post: post)
    }
    
    func subscribe(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.subscribe(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func unsubscribe(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.unsubscribe(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func saveUser(user: User) {
        self.interactor.saveUser(user: user)
    }
    
    func deleteUser(user: User) {
        self.interactor.deleteUser(user: user)
    }
    
    private func getAllUserPosts(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.getAllUserPosts(userID: userID, didNotComplete: didNotComplete) { [ weak self ] posts in
            self?.posts = posts
            self?.callBack?()
            
            didComplete()
        }
    }
    
}
