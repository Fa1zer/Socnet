//
//  SavedInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import Foundation

final class SavedInteractor {
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    private let coreDataManager: CoreDataManager
    
    func getPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        self.coreDataManager.getPosts(didComplete: didComplete)
    }
    
    func deletePost(postEntity: PostEntity, didComplete: @escaping () -> Void) {
        self.coreDataManager.deletePost(postEntity: postEntity, didComplete: didComplete)
    }
    
}
