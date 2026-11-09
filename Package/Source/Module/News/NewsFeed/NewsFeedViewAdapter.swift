// NewsFeedViewAdapter.swift
// By Artem Golovanev

import Combine
import Core
import Design
import UIKit

private typealias DataSource = UICollectionViewDiffableDataSource<NewsFeed.Section, News>
private typealias ViewObject = (news: News, image: UIImage?)

private enum Constants {
    static let threshold = 8
}

final class NewsFeedViewAdapter: NSObject {
    let subject = PassthroughSubject<NewsFeed.Action, Never>()
    
    private weak var collectionView: UICollectionView?
    
    private var isLoading = true
    private var images: [News: UIImage] = [:]
    private var dataSource: DataSource?
    
    private lazy var refreshAction = UIAction { [subject] _ in subject.send(.refresh) }
    private lazy var loadAction = UIAction { [subject] _ in subject.send(.loadMore) }
    
    private let elementKind = UICollectionView.elementKindSectionFooter
}

extension NewsFeedViewAdapter: ViewAdapter {
    func connect(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.refreshControl?.addAction(refreshAction, for: .valueChanged)
        dataSource = makeDataSource(for: collectionView)
    }
    
    func update(with state: NewsFeed.State) {
        images = state.images
        showNews(state.items)
        showFooterActivity(state.status == .idle || state.status == .loading)
        showError(for: state)
        showRefreshing(state.status != .refreshing)
    }
}

extension NewsFeedViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = dataSource?.itemIdentifier(for: indexPath) else { return }
        subject.send(.select(news))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let news = dataSource?.itemIdentifier(for: indexPath) else { return }
        requestImage(for: news)
        requestNextPage(at: indexPath, in: collectionView)
    }
}

private extension NewsFeedViewAdapter {
    func requestImage(for news: News) {
        guard images[news] == nil else { return }
        subject.send(.loadImage(news))
    }
    
    func requestNextPage(at indexPath: IndexPath, in view: UICollectionView) {
        let count = view.numberOfItems(inSection: indexPath.section)
        guard indexPath.item >= count - Constants.threshold else { return }
        subject.send(.loadMore)
    }
}

private extension NewsFeedViewAdapter {
    func showNews(_ items: [News]) {
        var snapshot = NSDiffableDataSourceSnapshot<NewsFeed.Section, News>()
        snapshot.appendSections([.news])
        snapshot.appendItems(items)
        snapshot.reconfigureItems(items)
        dataSource?.apply(snapshot)
    }
    
    func showFooterActivity(_ isLoading: Bool) {
        self.isLoading = isLoading
        guard let view = collectionView,
              let section = dataSource?.snapshot().indexOfSection(.news),
              let footer = view.supplementaryView(forElementKind: elementKind, at: IndexPath(item: 0, section: section)) as? LoaderView
        else { return }
        footer.update(with: isLoading)
    }
    
    func showRefreshing(_ isRefreshing: Bool) {
        guard !isRefreshing else { return }
        collectionView?.refreshControl?.endRefreshing()
    }
    
    func showError(for state: NewsFeed.State) {
        guard state.items.isEmpty, case let .failed(message) = state.status else {
            collectionView?.backgroundView = nil
            return
        }
        let view = UIContentUnavailableView(configuration: makeConfiguration(with: message))
        collectionView?.backgroundView = view
    }
}

private extension NewsFeedViewAdapter {
    func makeDataSource(for view: UICollectionView) -> DataSource {
        let cell = UICollectionView.CellRegistration<NewsFeedCell, NewsFeedCell.Item> { cell, _, item in
            cell.update(with: item)
        }
        
        let footer = UICollectionView.SupplementaryRegistration<LoaderView>(elementKind: elementKind) { [weak self] view, _, _ in
            view.update(with: self?.isLoading ?? false)
        }
        
        let dataSource = DataSource(collectionView: view) { [weak self] view, path, news in
            view.dequeueConfiguredReusableCell(using: cell, for: path, item: self?.makeViewObject(by: news))
        }
        dataSource.supplementaryViewProvider = { view, _, path in
            view.dequeueConfiguredReusableSupplementary(using: footer, for: path)
        }
        return dataSource
    }
    
    func makeConfiguration(with text: String) -> UIContentUnavailableConfiguration {
        var configuration = UIContentUnavailableConfiguration.empty()
        configuration.image = UI.Icon.nosign.image
        configuration.text = text
        configuration.button = .plain()
        configuration.button.title = Strings.retry
        configuration.buttonProperties.primaryAction = loadAction
        return configuration
    }
    
    func makeViewObject(by news: News) -> ViewObject {
        (news: news, image: images[news])
    }
}
