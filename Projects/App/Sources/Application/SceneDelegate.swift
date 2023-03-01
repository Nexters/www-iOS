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
        
        let launchVC = LaunchScreenViewController(viewModel: LaunchScreenViewModel(joinUserUseCase: JoinUserUseCase(userRepository: UserDAO.init(network: UserAPIManager.provider))))
        window?.rootViewController = UINavigationController(rootViewController: launchVC)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if UserDefaultKeyCase().getOnBoarding() {
                let mainHomeVC = MainHomeViewController(viewModel: MainHomeViewModel(mainHomeUseCase: .init(meetingRepository: MainHomeDAO.init(network: MeetingAPIManager.provider))))
                self.window?.rootViewController = UINavigationController(rootViewController: PlaceVoteViewController(viewmodel: PlaceVoteViewModel(usecase: PlaceVoteUseCase(repository: PlaceVoteDAO(network: VoteAPIManager.provider)), roomId: 71, status: .voting)))
            } else {
                lazy var onBoarding = OnBoardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.window?.rootViewController = UINavigationController(rootViewController: onBoarding)
            }
            
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}
