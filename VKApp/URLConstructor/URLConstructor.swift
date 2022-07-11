//
//  URLConstructor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

final class URLConstructor {
    
    init(urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw RequestErrors.badURL
        }
        
        self.baseURLString = url
    }
    
    private init() {
//        self.baseURLString = URL(string: BaseURLs.default.rawValue) ?? URL(fileURLWithPath: "")
        self.baseURLString = URL(string: BaseURLs.local.rawValue) ?? URL(fileURLWithPath: "")
    }
    
    static let `default` = URLConstructor.init()
    
    private let baseURLString: URL
    
    func auth() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.auth.rawValue)
    }
    
    func logOut() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.logOut.rawValue)
    }
    
    func allUsers() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.all.rawValue)
    }
    
    func meUser() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.me.rawValue)
    }
    
    func changeUser() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.change.rawValue)
    }
    
    func newUser() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.new.rawValue)
    }
    
    func user(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.user.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func userSubscribtions(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.user.rawValue)
            .appendingPathComponent(URLPaths.subscribtions.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func userSubscribers(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.user.rawValue)
            .appendingPathComponent(URLPaths.subscribers.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func userPosts(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func subscribe(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.subscribe.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func unsubscribe(userID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.users.rawValue)
            .appendingPathComponent(URLPaths.unsubscribe.rawValue)
            .appendingPathComponent(userID.uuidString)
    }
    
    func allPosts() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(URLPaths.all.rawValue)
    }
    
    func newPost() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(URLPaths.new.rawValue)
    }
    
    func deletePost(postID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(URLPaths.delete.rawValue)
            .appendingPathComponent(postID.uuidString)
    }
    
    func like(postID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(URLPaths.like.rawValue)
            .appendingPathComponent(postID.uuidString)
    }
    
    func dislike(postID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(URLPaths.dislike.rawValue)
            .appendingPathComponent(postID.uuidString)
    }
    
    func postComments(postID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.posts.rawValue)
            .appendingPathComponent(postID.uuidString)
            .appendingPathComponent(URLPaths.comments.rawValue)
    }
    
    func newComent() -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.comments.rawValue)
            .appendingPathComponent(URLPaths.new.rawValue)
    }
    
    func comentUser(commentID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.comments.rawValue)
            .appendingPathComponent(commentID.uuidString)
            .appendingPathComponent(URLPaths.user.rawValue)
    }
    
    func deleteComment(commentID: UUID) -> URL {
        self.baseURLString
            .appendingPathComponent(URLPaths.comments.rawValue)
            .appendingPathComponent(commentID.uuidString)
            .appendingPathComponent(URLPaths.delete.rawValue)
    }
    
}
