//
//  UserDefaultsManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 12.07.2022.
//

import Foundation

final class UserDefaultsManager {
    
    private let userDefauts = UserDefaults()
    
    func saveUserData(avatarImageDataString: String?, userName: String?, id: UUID?) {
        self.userDefauts.set(avatarImageDataString, forKey: UserDefaultsManagerKeys.image.rawValue)
        self.userDefauts.set(userName, forKey: UserDefaultsManagerKeys.name.rawValue)
        self.userDefauts.set(id?.uuidString, forKey: UserDefaultsManagerKeys.id.rawValue)
    }
    
    func getUserData() -> (image: String, name: String, id: String)? {
        guard let image = self.userDefauts.string(forKey: UserDefaultsManagerKeys.image.rawValue),
              let name = self.userDefauts.string(forKey: UserDefaultsManagerKeys.name.rawValue),
              let id = self.userDefauts.string(forKey: UserDefaultsManagerKeys.id.rawValue) else {
            return nil
        }
        
        return (image: image, name: name, id: id)
    }
    
}
