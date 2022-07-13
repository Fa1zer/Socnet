//
//  CreatePostInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 11.07.2022.
//

import Foundation

final class CreatePostInteractor {
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    private let dataManager: DataManager
    
    func createPost(post: Post, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.postNewPost(post: post, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
