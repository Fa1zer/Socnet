//
//  CommentsInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import Foundation

final class CommentsInteractor {
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager, userDefaultsManager: UserDefaultsManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    private let userDefaultsManager: UserDefaultsManager
    
    func getComments(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Comment]) -> Void) {
        self.dataManager.getAllPostComments(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        self.coreDataManager.getUsers(didComplete: didComplete)
    }
    
    func createComment(comment: Comment, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.dataManager.postComment(comment: comment, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getUserData() -> (image: String, name: String, id: String)? {
        self.userDefaultsManager.getUserData()
    }
    
    func getUser(commentID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        self.dataManager.getCommentUser(commentID: commentID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
