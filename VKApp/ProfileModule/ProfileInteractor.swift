//
//  ProfileInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 06.07.2022.
//

import Foundation

final class ProfileInteractor {
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
    }
    
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    
    func getUser(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.dataManager.getUser(didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
    func getSomeUser(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.dataManager.getSomeUser(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getAllUserPosts(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Post]) -> Void) {
        self.dataManager.getAllUserPosts(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func like(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.like(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getAllCoreDataPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.coreDataManager.getPosts(didComplete: didComplete)
    }
    
    func save(post: Post, user: User) {
        self.coreDataManager.savePost(post: post, user: user)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func deletePost(post: Post) {
        self.coreDataManager.deletePost(post: post, didComplete: { })
    }
    
    func subscribe(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.subscribe(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func unsubscribe(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.unsubscribe(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func saveUser(user: User) {
        self.coreDataManager.saveUser(user: user)
    }
    
    func deleteUser(user: User) {
        self.coreDataManager.deleteUser(user: user) { }
    }
    
}
