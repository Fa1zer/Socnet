//
//  SavedInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import Foundation

final class SavedInteractor {
    
    init(coreDataManager: CoreDataManager, dataManager: DataManager) {
        self.coreDataManager = coreDataManager
        self.dataManager = dataManager
    }
    
    private let coreDataManager: CoreDataManager
    private let dataManager: DataManager
    
    func getPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.coreDataManager.getPosts(didComplete: didComplete)
    }
    
    func deletePost(post: Post, didComplete: @escaping () -> Void) {
        self.coreDataManager.deletePost(post: post, didComplete: didComplete)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
