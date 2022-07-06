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
        self.coreDataManager.save(post: post, user: user)
    }
    
}
