// NewsFeedBuilder.swift
// By Artem Golovanev

import Combine
import Core
import Design
import UIKit

public final class NewsFeedBuilder: Observable {
    public let subject = PassthroughSubject<News, Never>()
    
    private let service: any NewsFetching
    private let imageLoader: any ImageLoading
    private let appearanceStore: AppearanceStore

    public init(
        service: any NewsFetching,
        imageLoader: any ImageLoading,
        appearanceStore: AppearanceStore
    ) {
        self.service = service
        self.imageLoader = imageLoader
        self.appearanceStore = appearanceStore
    }

    public var controller: UIViewController {
        let adapter = NewsFeedViewAdapter()
        let view = NewsFeedView(adapter: adapter)
        let viewModel = NewsFeedViewModel(
            service: service,
            imageLoader: imageLoader,
            route: subject
        )
        return NewsFeedController(
            contentView: view,
            viewModel: viewModel,
            appearanceStore: appearanceStore
        )
    }
}
