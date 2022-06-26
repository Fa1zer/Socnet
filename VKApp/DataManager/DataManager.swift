//
//  DataManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

final class DataManager {
    
    var callBack: (() -> Void)?
    var allPosts = [Post]() {
        didSet {
            // call
        }
    }
    
    var allUserPosts = [Post]() {
        didSet {
            // call
        }
    }
    
    var user: User? {
        didSet {
            if let user = user {
                // user
            }
        }
    }
    
    var someUser: User? {
        didSet {
            if let someUser = someUser {
                // call
            }
        }
    }
    
    var someUserPosts = [Post]() {
        didSet {
            // call
        }
    }
    
    var postComments = [Comment]() {
        didSet {
            // call
        }
    }
    
    private let urlConstructor = URLConstructor.default
    private var userToken: String? {
        didSet {
            if let userToken = userToken {
                // call
            }
        }
    }
    
}
