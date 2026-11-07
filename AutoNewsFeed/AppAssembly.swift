// AppAssembly.swift
// By Artem Golovanev

import Core
import Design
import Network
import UIKit

struct AppAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register((any NewsServiceProtocol).self, NewsService())
        container.register((any ImageLoaderProtocol).self, ImageLoader())
        container.register(AppearanceStore.self, AppearanceStore(with: .standard))
        container.register(AppCoordinator.self, AppCoordinator(
            service: container.resolve(),
            imageLoader: container.resolve(),
            appearanceStore: container.resolve()
        ))
    }
}
