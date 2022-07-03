//
//  EditPresenter.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 01.07.2022.
//

import Foundation

final class EditPresenter {
    
    init(interactor: EditInteractor, router: EditRouter) {
        self.interacotor = interactor
        self.router = router
    }
    
    private let interacotor: EditInteractor
    private let router: EditRouter
    
    func editUser(user: User, didComplete: @escaping () -> Void, didNotComplete: @escaping (RequestErrors) -> Void) {
        self.interacotor.editUser(user: user, didComplete: didComplete, didNotComplete: didNotComplete)
    }
    
    func goToTabBar() {
        self.router.goToTabBar()
    }
    
}
