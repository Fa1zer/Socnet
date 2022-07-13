//
//  CreatePostPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 11.07.2022.
//

import Foundation

final class CreatePostPresenter {
    
    init(interactor: CreatePostInteractor, router: CreatePostRouter, userID: UUID) {
        self.interactror = interactor
        self.router = router
        self.userID = userID
    }
    
    private let interactror: CreatePostInteractor
    private let router: CreatePostRouter
    let userID: UUID
    
    func createPost(post: Post, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactror.createPost(post: post, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func goToProfile() {
        self.router.goToProfile()
    }
    
}
