//
//  FindUserInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 13.07.2022.
//

import Foundation

final class FindUserInteractor {
    
    init(dataManager: DataManager, coreDataManager: CoreDataManager) {
        self.dataManager = dataManager
        self.coreDataManager = coreDataManager
    }
    
    private let dataManager: DataManager
    private let coreDataManager: CoreDataManager
    
    func getUserSubscribers(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([User]) -> Void) {
        self.dataManager.getUserSubscribers(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getUserSubscribtions(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([User]) -> Void) {
        self.dataManager.getUserSubscribtions(userID: userID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func getUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        self.coreDataManager.getUsers(didComplete: didComplete)
    }
    
}
