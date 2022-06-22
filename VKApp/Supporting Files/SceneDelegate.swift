//
//  SceneDelegate.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 08.06.2022.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = RegistrationCoordinator().navigationController
        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene
    }
    
}

