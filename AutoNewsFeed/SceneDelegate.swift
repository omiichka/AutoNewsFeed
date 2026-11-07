// SceneDelegate.swift
// By Artem Golovanev

import Core
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let container = DIContainer()
    private lazy var coordinator: AppCoordinator = container.resolve()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        AppAssembly().assemble(container: container)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.navigationController
        coordinator.start()
        window.makeKeyAndVisible()
        self.window = window
    }
}
