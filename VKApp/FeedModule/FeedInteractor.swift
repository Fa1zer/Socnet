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
        self.coreDataManager.save(post: post, user: user)
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
    
}
