//
//  FindUserPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 13.07.2022.
//

import Foundation

final class FindUserPresenter {
    
    init(interactor: FindUserInteractor, router: FindUserRouter, mode: FindUserMode, userID: UUID) {
        self.interactor = interactor
        self.router = router
        self.mode = mode
        self.userID = userID
    }
    
    var callBack: (() -> Void)?
    let userID: UUID
    let mode: FindUserMode
    private let interactor: FindUserInteractor
    private let router: FindUserRouter
    
    private(set) var users = [User]() {
        didSet {
            guard !self.users.isEmpty else {
                return
            }
            
            self.callBack?()
        }
    }
    
    private(set) var usersEntity = [UserEntity]() {
        didSet {
            guard !self.usersEntity.isEmpty else {
                return
            }
            
            self.callBack?()
        }
    }
    
    func getUserSubscribers(didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interactor.getUserSubscribers(userID: self.userID, didNotComplete: didNotComplete) { [ weak self ] users in
            self?.users = []
            
            for user in users {
                self?.users.append(user)
            }
            
            self?.callBack?()
        }
    }
    
    func getUserSubscribtions(didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interactor.getUserSubscribtions(userID: self.userID, didNotComplete: didNotComplete) { [ weak self ] users in
            self?.users = []
            
            for user in users {
                self?.users.append(user)
            }
            
            self?.callBack?()
        }
    }
    
    func getUsers() {
        self.interactor.getUsers { [ weak self ] users in
            self?.usersEntity = []
            
            for user in users {
                self?.usersEntity.append(user)
            }
            
            self?.callBack?()
        }
    }
    
    func goToProfile(userID: UUID, isSubscribedUser: Bool) {
        self.router.goToProfile(userID: userID, isSubscribedUser: isSubscribedUser)
    }
    
}
