//
//  SavedPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import Foundation
import UIKit

final class SavedPresenter {
    
    init(router: SavedRouter, interactor: SavedInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
    private let router: SavedRouter
    private let interactor: SavedInteractor
    
    private(set) var posts = [(post: Post, user: User)]()
    
    func getPosts() {
        self.interactor.getPosts { [ weak self ] postEntities in
            self?.posts = []
            
            for postEntity in postEntities {
                self?.posts.append((
                    post: Post(
                        id: postEntity.id,
                        userID: postEntity.userID ?? UUID(),
                        image: postEntity.image?.base64EncodedString() ?? "",
                        text: postEntity.text ?? "",
                        likes: -1
                    ),
                    user: User(
                        id: postEntity.userID,
                        email: "",
                        passwordHash: "",
                        name: postEntity.userName ?? "",
                        image: postEntity.image?.base64EncodedString()
                    )
                ))
            }
        }
    }
    
    func deletePost(post: Post, didComplete: @escaping () -> Void) {
        self.interactor.deletePost(post: post, didComplete: didComplete)
    }
    
    func dislike(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        self.interactor.dislike(postID: postID, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
    func goToProfile(userID: UUID?) {
        self.router.goToProfile(userID: userID, isSubscribedUser: true)
    }
    
}
