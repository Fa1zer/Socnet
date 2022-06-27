//
//  DataManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 25.06.2022.
//

import Foundation

final class DataManager {
        
    private let urlConstructor = URLConstructor.default
    private var userToken: String?
   
//    MARK: Post User
    func postUser(user: User, didNotComplete: @escaping (LogInErrors) -> Void, didComplete: @escaping () -> Void) {
        do {
            var request = URLRequest(url: self.urlConstructor.newUser())
            let data = ["email" : user.email, "password" : user.passwordHash]
            
            request.httpMethod = HTTPMethods.POST.rawValue
            request.setValue(HTTPHeaders.applicationJson.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
            request.httpBody = try JSONEncoder().encode(data)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    didNotComplete(.someError(error))
                    
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                    
                    didNotComplete(.requestError(.statusCodeError((response as? HTTPURLResponse)?.statusCode)))
                    
                    return
                }
                
                didComplete()
            }
            .resume()
        } catch {
            print("❌ Error: encode failed")
            
            didNotComplete(.requestError(.encodeFailed))
        }
    }
    
//    MARK: Autorization User
    func auth(email: String, password: String, didComplete: @escaping () -> Void, didNotComplete: @escaping (SignInErrors) -> Void) {
        var request = URLRequest(url: self.urlConstructor.auth())
        
        guard let authString = HTTPHeaders.authString(email: email, password: password) else {
            print("❌ Error: authorization string is equal to nil")
            
            didNotComplete(.someError(nil))
            
            return
        }
        
        request.setValue(authString, forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                didNotComplete(.requestError(.statusCodeError((response as? HTTPURLResponse)?.statusCode)))
                
                return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.requestError(.dataError))
                
                return
            }
            
            guard let userToken = try? JSONDecoder().decode(UserToken.self, from: data) else {
                print("❌ Error: decode failed")
                
                didNotComplete(.requestError(.decodeFailed))
                
                return
            }
            
            self.userToken = userToken.value
            
            didComplete()
        }
        .resume()
    }
    
//    MARK: Get User
    func getUser(didComplete: @escaping (User) -> Void, didNotComplete: @escaping (RequestErrors) -> Void) {
        var request = URLRequest(url: self.urlConstructor.meUser())
        
        guard let userToken = userToken else {
            return
        }
        
        request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                print("❌ Error: decode failed")
                
                didNotComplete(.decodeFailed)
                
                return
            }
            
            didComplete(user)
        }
        .resume()
    }
   
//    MARK: Put User
    func putUser(user: User, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        do {
            var request = URLRequest(url: self.urlConstructor.changeUser())
            
            guard let userToken = userToken else {
                return
            }
            
            request.httpMethod = HTTPMethods.PUT.rawValue
            request.setValue(HTTPHeaders.applicationJson.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
            request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
            request.httpBody = try JSONEncoder().encode(user)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    didNotComplete(.someError(error))
                    
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                    
                        didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                    
                        return
                }
                
                didComplete()
            }
            .resume()
        } catch {
            print("❌ Error: encode failed")
            
            didNotComplete(.encodeFailed)
        }
    }
    
//    MARK: Get All Users
    func allUsers(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([User]) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.allUsers()) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let users = try? JSONDecoder().decode([User].self, from: data) else {
                print("❌ Error: decoder failed")
                
                didNotComplete(.decodeFailed)
                
                return
            }
            
            didComplete(users)
        }
        .resume()
    }
    
//    MARK: Get Some User
    func getSomeUser(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.user(userID: userID)) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            didComplete(user)
        }
        .resume()
    }
    
//    MARK: Get All User Posts
    func getAllUserPosts(userID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Post]) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.userPosts(userID: userID)) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                print("❌ Error: decoder failed")
                
                didNotComplete(.decodeFailed)
                
                return
            }
            
            didComplete(posts)
        }
        .resume()
    }
    
//    MARK: Get All Posts
    func getAllPosts(didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Post]) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.allPosts()) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                print("❌ Error: decoder failed")
                
                didNotComplete(.decodeFailed)
                
                return
            }
            
            didComplete(posts)
        }
        .resume()
    }
    
//    MARK: Get All Post Comments
    func getAllPostComments(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping ([Comment]) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.postComments(postID: postID)) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let comments = try? JSONDecoder().decode([Comment].self, from: data) else {
                print("❌ Error: decoder failed")
                
                didNotComplete(.decodeFailed)
                
                return
            }
            
            didComplete(comments)
        }
        .resume()
    }
    
//    MARK: Post(method) New Post
    func postNewPost(post: Post, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        do {
            var request = URLRequest(url: self.urlConstructor.newPost())
            
            guard let userToken = userToken else {
                return
            }
            
            request.httpMethod = HTTPMethods.POST.rawValue
            request.setValue(HTTPHeaders.applicationJson.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
            request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
            request.httpBody = try JSONEncoder().encode(post)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    didNotComplete(.someError(error))
                    
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                    
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                    
                    return
                }
                
                didComplete()
            }
            .resume()
        } catch {
            print("❌ Error: encode failed")
            
            didNotComplete(.encodeFailed)
        }
    }
    
//    MARK: Delete Post
    func deletePost(postID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        var request = URLRequest(url: self.urlConstructor.deletePost(postID: postID))
        
        guard let userToken = userToken else {
            return
        }
        
        request.httpMethod = HTTPMethods.DELETE.rawValue
        request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                return
            }
            
            didComplete()
        }
        .resume()
    }
    
//    MARK: Get User Comment
    func getCommentUser(commentID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping (User) -> Void) {
        URLSession.shared.dataTask(with: self.urlConstructor.comentUser(commentID: commentID)) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                    return
            }
            
            guard let data = data else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            guard let user = try? JSONDecoder().decode(User.self, from: data) else {
                print("❌ Error: data is equal to nil")
                
                didNotComplete(.dataError)
                
                return
            }
            
            didComplete(user)
        }
        .resume()
    }
    
//    MARK: Post Comment
    func postComment(comment: Comment, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        do {
            var request = URLRequest(url: self.urlConstructor.newComent())
            
            guard let userToken = userToken else {
                return
            }
            
            request.httpMethod = HTTPMethods.POST.rawValue
            request.setValue(HTTPHeaders.applicationJson.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
            request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
            request.httpBody = try JSONEncoder().encode(comment)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    didNotComplete(.someError(error))
                    
                    return
                }
                
                guard let httpURLResponse = response as? HTTPURLResponse,
                      httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                    
                    didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                    
                    return
                }
                
                didComplete()
            }
            .resume()
        } catch {
            print("❌ Error: encode failed")
            
            didNotComplete(.encodeFailed)
        }
    }
    
//    MARK: Delete Comment
    func deleteComment(commentID: UUID, didNotComplete: @escaping (RequestErrors) -> Void, didComplete: @escaping () -> Void) {
        var request = URLRequest(url: self.urlConstructor.deleteComment(commentID: commentID))
        
        guard let userToken = userToken else {
            return
        }
        
        request.httpMethod = HTTPMethods.DELETE.rawValue
        request.setValue(HTTPHeaders.bearerAuthString(token: userToken), forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                didNotComplete(.someError(error))
                
                return
            }
            
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200 else {
                print("❌ Error: status code is equal to \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                
                didNotComplete(.statusCodeError((response as? HTTPURLResponse)?.statusCode))
                
                return
            }
            
            didComplete()
        }
        .resume()
    }
    
}
