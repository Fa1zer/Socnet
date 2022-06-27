//
//  HTTPHeaders.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 26.06.2022.
//

import Foundation

enum HTTPHeaders: String {
    case applicationJson = "application/json"
    case contentType = "Content-Type"
    case authorization = "Authorization"
    
    static func authString(email: String, password: String) -> String? {
        guard let authString = "\(email):\(password)".data(using: .utf8)?.base64EncodedString() else {
            return nil
        }
        
        return "Basic \(authString)"
    }
    
    static func bearerAuthString(token: String) -> String {
        return "Bearer \(token)"
    }
}
