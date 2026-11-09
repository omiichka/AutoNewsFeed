// NewsDetailViewModel.swift
// By Artem Golovanev

import Combine
import Core
import Foundation

private typealias LoadingTask = Task<Void, Never>

final class NewsDetailViewModel {
    let subject = CurrentValueSubject<NewsDetail.State, Never>(NewsDetail.State())

    private let news: News
    private let service: any NewsFetching
    private let imageLoader: any ImageLoading
    private let parser: any ArticleParsing

    private var loadTask: LoadingTask?
    private var imageTasks: [URL: LoadingTask] = [:]

    init(
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

    deinit {
        loadTask?.cancel()
        imageTasks.values.forEach { $0.cancel() }
    }
}

extension NewsDetailViewModel: ViewModel {
    func send(_ input: NewsDetail.Action) {
        switch input {
            case .load:
                load()
            case let .loadImage(url):
                loadImage(from: url)
        }
    }
}

private extension NewsDetailViewModel {
    func load() {
        guard loadTask == nil else { return }
        subject.value.status = .loading
        loadTask = Task { [weak self, service, news] in
            do {
                let article = try await service.fetchArticle(path: news.path)
                self?.didLoad(article)
            } catch {
                self?.didFail(error)
            }
        }
    }
    
    func loadImage(from url: URL) {
        guard subject.value.images[url] == nil, imageTasks[url] == nil else { return }
        imageTasks[url] = Task { [weak self, imageLoader] in
            let image = try? await imageLoader.image(for: url)
            self?.imageTasks[url] = nil
            self?.subject.value.images[url] = image
        }
    }

    func didLoad(_ article: News) {
        loadTask = nil
        subject.value.blocks = parser.blocks(for: article)
        subject.value.status = .loaded
    }

    func didFail(_ error: any Error) {
        loadTask = nil
        subject.value.status = .failed(error.localizedDescription)
    }
}
