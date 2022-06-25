//
//  Comment.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

struct Comment: Codable {
    
    var id: UUID?
    var userID: UUID
    var postID: UUID
    var text: String
    
    init(id: UUID? = nil, userID: UUID, postID: UUID, text: String) {
        self.id = id
        self.userID = userID
        self.postID = postID
        self.text = text
    }
    
}
