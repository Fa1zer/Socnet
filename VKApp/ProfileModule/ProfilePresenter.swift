//
//  ProfilePresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import Foundation

final class ProfilePresenter {
    
    init(router: ProfileRouter, interactor: ProfileInteractor, isAlienUser: Bool) {
        self.router = router
        self.interactor = interactor
        self.isAlienUser = isAlienUser
    }
    
    var callBack: (() -> Void)?
    
    private let router: ProfileRouter
    private let interactor: ProfileInteractor
    let isAlienUser: Bool
    
    private(set) var posts = [Post]()
    private(set) var user: User?
    
    func getUser(didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interactor.getUser(didNotComplete: didNotComplete) { [ weak self ] user in
            self?.user = user
            self?.callBack?()
            
            guard let id = user.id else {
                return
            }
            
            self?.getAllUserPosts(userID: id) { error in
                print("❌ Error: \(error.localizedDescription)")
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
    
    private func getAllUserPosts(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interactor.getAllUserPosts(userID: userID, didNotComplete: didNotComplete) { [ weak self ] posts in
            self?.posts = posts
            self?.callBack?()
        }
    }
    
}
