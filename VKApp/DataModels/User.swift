//
//  UserModel.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

struct User: Codable {
    
    var id: UUID?
    var email: String
    var passwordHash: String
    var name: String
    var work: String
    var subscribers: [UUID]
    var subscribtions: [UUID]
    var images: [String]
    var image: String?
    
    init(id: UUID? = nil, email: String, passwordHash: String, name: String, work: String = "", subscribers: [UUID] = [], subscribtions: [UUID] = [], images: [String] = [], image: String? = nil) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.name = name
        self.work = work
        self.subscribers = subscribers
        self.subscribtions = subscribtions
        self.images = images
        self.image = image
    }
    
}
