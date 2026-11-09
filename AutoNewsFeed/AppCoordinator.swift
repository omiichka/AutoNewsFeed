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
    private let parser: any ArticleParsing
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
        appearanceStore: AppearanceStore,
        parser: any ArticleParsing
    ) {
        self.navigationController = navigationController
        self.service = service
        self.imageLoader = imageLoader
        self.appearanceStore = appearanceStore
        self.parser = parser
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
        let detail = NewsDetailBuilder(news: news, service: service, imageLoader: imageLoader, parser: parser).controller
        navigationController.pushViewController(detail, animated: true)
    }
    
    func bind() {
        builder
            .publisher
            .sink { [weak self] news in self?.showDetail(for: news) }
            .store(in: &bag)
    }
}
