// NewsFeedViewModel.swift
// By Artem Golovanev

import Combine
import Core

private typealias LoadingTask = Task<Void, Never>

private enum Constants {
    static let firstPage = 1
    static let pageSize = 10
}

final class NewsFeedViewModel {
    let subject = CurrentValueSubject<NewsFeed.State, Never>(NewsFeed.State())
    
    private let service: any NewsFetching
    private let imageLoader: any ImageLoading
    
    private let pageSize: Int
    private var nextPage = Constants.firstPage
    
    private let route: PassthroughSubject<News, Never>
    
    private var loadTask: LoadingTask?
    private var imageTasks: [News: LoadingTask] = [:]
    
    init(
        service: any NewsFetching,
        imageLoader: any ImageLoading,
        pageSize: Int = Constants.pageSize,
        route: PassthroughSubject<News, Never>
    ) {
        self.service = service
        self.imageLoader = imageLoader
        self.pageSize = pageSize
        self.route = route
    }
    
    deinit {
        loadTask?.cancel()
        imageTasks.values.forEach { $0.cancel() }
    }
}

extension NewsFeedViewModel: ViewModel {
    func send(_ input: NewsFeed.Action) {
        switch input {
            case .loadMore:
                checkStatus()
            case .refresh:
                load(page: Constants.firstPage, status: .refreshing)
            case let .select(news):
                route.send(news)
            case let .loadImage(news):
                loadImage(for: news)
        }
    }
}

private extension NewsFeedViewModel {
    func load(page: Int, status: NewsFeed.Status = .loading) {
        loadTask?.cancel()
        subject.value.status = status
        loadTask = Task { [weak self, service, pageSize] in
            do {
                let result = try await service.fetchNews(page: page, count: pageSize)
                guard !Task.isCancelled else { return }
                self?.didLoad(result, page: page)
            } catch {
                guard !Task.isCancelled else { return }
                self?.didFail(error)
            }
        }
    }
    
    func didLoad(_ result: NewsPage, page: Int) {
        loadTask = nil
        var newState = subject.value
        if page == Constants.firstPage { newState.items = [] }
        var known = Set(newState.items)
        let fresh = result.items.filter { known.insert($0).inserted }
        newState.items += fresh
        let isLastPage = result.items.isEmpty || page * pageSize >= result.totalCount
        newState.status = isLastPage ? .allLoaded : .idle
        nextPage = page + 1
        subject.value = newState
        if fresh.isEmpty, !isLastPage {
            load(page: nextPage)
        }
    }
    
    func loadImage(for news: News) {
        guard subject.value.images[news] == nil, imageTasks[news] == nil, let url = news.imageURL else { return }
        imageTasks[news] = Task { [weak self] in
            let image = try? await self?.imageLoader.image(for: url)
            self?.imageTasks[news] = nil
            self?.subject.value.images[news] = image
        }
    }
    
    func didFail(_ error: any Error) {
        loadTask = nil
        subject.value.status = .failed(error.localizedDescription)
    }
    
    func checkStatus() {
        switch subject.value.status {
            case .idle, .failed:
                load(page: nextPage)
            case .loading, .refreshing, .allLoaded:
                return
        }
    }
}
