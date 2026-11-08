// SceneDelegate.swift
// By Artem Golovanev

import Combine
import Core
import Design
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let container = DIContainer()
    private lazy var coordinator: AppCoordinator = container.resolve()
    private lazy var appearanceStore: AppearanceStore = container.resolve()
    private var bag = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        AppAssembly().assemble(container: container)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = coordinator.navigationController
        bindAppearance(to: window)
        coordinator.start()
        window.makeKeyAndVisible()
        self.window = window
    }
}

private extension SceneDelegate {
    func bindAppearance(to window: UIWindow) {
        appearanceStore.publisher
            .sink { [weak window] appearance in
                guard let window else { return }
                UIView.transition(with: window, duration: 0.25, options: .curveEaseInOut) {
                    window.overrideUserInterfaceStyle = appearance.style
                }
            }
            .store(in: &bag)
    }
}
