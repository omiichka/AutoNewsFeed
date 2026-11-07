// AppCoordinator.swift
// By Artem Golovanev

import Core
import Design
import News
import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController

    private let service: any NewsServiceProtocol
    private let imageLoader: any ImageLoaderProtocol
    private let appearanceStore: AppearanceStore

    init(
        navigationController: UINavigationController = .init(),
        service: any NewsServiceProtocol,
        imageLoader: any ImageLoaderProtocol,
        appearanceStore: AppearanceStore
    ) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
        self.appearanceStore = appearanceStore
    }

    func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        let feed = NewsFeedBuilder(
            service: service,
            imageLoader: imageLoader,
            appearanceStore: appearanceStore
        ) { [weak self] news in
            self?.showDetail(for: news)
        }.controller
        navigationController.setViewControllers([feed], animated: false)
    }
}

private extension AppCoordinator {
    func showDetail(for news: News) {
        guard let url = news.webURL else { return }
        navigationController.pushViewController(NewsDetailController(url: url), animated: true)
    }
}
