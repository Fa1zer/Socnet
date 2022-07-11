//
//  FeedInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 05.07.2022.
//

import Foundation

final class FeedInteractor {
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
    }
    
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    
    func save(post: Post, user: User) {
        self.coreDataManager.savePost(post: post, user: user)
    }
    
    func getAllPost(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Post]) -> Void) {
        self.dataManager.getAllPosts(didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getSomeUser(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.dataManager.getSomeUser(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getAllCoreDataPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.coreDataManager.getPosts(didComplete: didComplete)
    }
    
    func getAllCoreDataUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        self.coreDataManager.getUsers(didComplete: didComplete)
    }
    
    func like(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.like(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func deletePost(post: Post) {
        self.coreDataManager.deletePost(post: post, didComplete: { })
    }
    
}
