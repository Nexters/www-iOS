//
//  SceneDelegate.swift
//  www
//
//  Created by Chanhee Jeong on 2023/01/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let sampleVC = SampleViewController(viewModel: SampleViewModel(joinUserUseCase: JoinUserUseCase(userRepository: UserDAO.init(network: RxMoyaProvider<UserAPI>()).makeUserRepository())))
        window?.rootViewController = sampleVC
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}
