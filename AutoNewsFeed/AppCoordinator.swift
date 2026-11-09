// AppCoordinator.swift
// By Artem Golovanev

import Combine
import Core
import Design
import News
import UIKit

final class AppCoordinator {
    let navigationController: UINavigationController

    private let service: any NewsFetching
    private let imageLoader: any ImageLoading
    private let appearanceStore: AppearanceStore
    private var bag = Set<AnyCancellable>()
    
    private lazy var builder: NewsFeedBuilder = {
       NewsFeedBuilder(
            service: service,
            imageLoader: imageLoader,
            appearanceStore: appearanceStore
        )
    }()

    init(
        navigationController: UINavigationController = .init(),
        service: any NewsFetching,
        imageLoader: any ImageLoading,
        appearanceStore: AppearanceStore
    ) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
        self.appearanceStore = appearanceStore
    }
}

extension AppCoordinator: Coordinator {
    func start() {
        bind()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([builder.controller], animated: false)
    }
}

private extension AppCoordinator {
    func showDetail(for news: News) {
        guard let url = news.webURL else { return }
        navigationController.pushViewController(NewsDetailController(url: url), animated: true)
    }
    
    func bind() {
        builder
            .publisher
            .sink { [weak self] news in self?.showDetail(for: news) }
            .store(in: &bag)
    }
}
