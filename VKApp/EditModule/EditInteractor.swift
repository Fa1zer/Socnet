//
//  EditInteractor.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import Foundation

final class EditInteractor {
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    private let dataManager: DataManager
    
    func editUser(user: User, didComplete: @escaping () -> Void, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.dataManager.putUser(user: user, didNotComplete: didNotComplete, didComplete: didComplete)
    }
    
}
