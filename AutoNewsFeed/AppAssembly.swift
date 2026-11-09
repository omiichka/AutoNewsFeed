// AppAssembly.swift
// By Artem Golovanev

import Core
import Design
import Foundation
import Network

struct AppAssembly: Assembly {
    func assemble(container: DIContainer) {
        container.register((any NewsFetching).self, NewsService())
        container.register((any ImageLoading).self, ImageLoader())
        container.register(AppearanceStore.self, AppearanceStore(with: .standard))
        container.register((any ArticleParsing).self, ArticleParser())
        container.register(AppCoordinator.self, AppCoordinator(
            service: container.resolve(),
            imageLoader: container.resolve(),
            appearanceStore: container.resolve(),
            parser: container.resolve()
        ))
    }
}
