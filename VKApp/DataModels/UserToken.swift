//
//  UserToken.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

struct UserToken: Decodable {
    var id: UUID?
    var value: String
}
