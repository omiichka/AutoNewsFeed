// NewsDetailBuilder.swift
// By Artem Golovanev

import Core
import UIKit

public struct NewsDetailBuilder {
    private let news: News
    private let service: any NewsFetching
    private let imageLoader: any ImageLoading
    private let parser: any ArticleParsing

    public init(
        news: News,
        service: any NewsFetching,
        imageLoader: any ImageLoading,
        parser: any ArticleParsing
    ) {
        self.news = news
        self.service = service
        self.imageLoader = imageLoader
        self.parser = parser
    }

    public var controller: UIViewController {
        let adapter = NewsDetailViewAdapter()
        let view = NewsDetailView(adapter: adapter)
        let viewModel = NewsDetailViewModel(news: news, service: service, imageLoader: imageLoader, parser: parser)
        return NewsDetailController(contentView: view, viewModel: viewModel)
    }
}
