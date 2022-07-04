//
//  EditPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import Foundation

final class EditPresenter {
    
    init(interactor: EditInteractor, router: EditRouter, isFirstEdit: Bool) {
        self.interacotor = interactor
        self.router = router
        self.isFirstEdit = isFirstEdit
    }
    
    var user: User?
    
    let isFirstEdit: Bool
    private let interacotor: EditInteractor
    private let router: EditRouter
    
    func editUser(user: User, didComplete: @escaping () -> Void, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interacotor.editUser(user: user, didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
    func logOut(didComplete: @escaping () -> Void, didNotComplete: @escaping (SignInErrors) -> Void) {
        self.interacotor.logOut(didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
    func deleteKeychainData() {
        self.interacotor.deleteKeychainData()
    }
    
    func goToTabBar() {
        self.router.goToTabBar()
    }
    
    func goToOnboarding() {
        self.router.goToOnboarding()
    }
    
}
