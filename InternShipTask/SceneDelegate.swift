//
//  SceneDelegate.swift
//  InternShipTask
//
//  Created by ARMBP on 8/26/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController(rootViewController: MainVC())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}

