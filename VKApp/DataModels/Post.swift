//
//  Post.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

struct Post: Codable {
    
    var id: UUID?
    var userID: UUID
    var image: String
    var text: String
    var likes: Int
    
    init(id: UUID? = nil, userID: UUID, image: String, text: String = "", likes: Int = .zero) {
        self.id = id
        self.userID = userID
        self.image = image
        self.text = text
        self.likes = likes
    }
    
}
