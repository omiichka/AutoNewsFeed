// NewsDetailViewAdapter.swift
// By Artem Golovanev

import Combine
import Core
import Design
import UIKit

private typealias DataSource = UICollectionViewDiffableDataSource<NewsDetail.Section, Int>

final class NewsDetailViewAdapter: NSObject {
    let subject = PassthroughSubject<NewsDetail.Action, Never>()

    private weak var collectionView: UICollectionView?

    private var dataSource: DataSource?
    private var blocks: [ArticleBlock] = []
    private var images: [URL: UIImage] = [:]
    
    private lazy var loadAction = UIAction { [subject] _ in subject.send(.load) }
}

extension NewsDetailViewAdapter: ViewAdapter {
    func connect(with collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        dataSource = makeDataSource(for: collectionView)
    }

    func update(with state: NewsDetail.State) {
        blocks = state.blocks
        images = state.images
        showBlocks()
        showStatus(state.status)
    }
}

extension NewsDetailViewAdapter: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard case let .image(url) = blocks[indexPath.item], images[url] == nil else { return }
        subject.send(.loadImage(url))
    }
}

private extension NewsDetailViewAdapter {
    func showBlocks() {
        var snapshot = NSDiffableDataSourceSnapshot<NewsDetail.Section, Int>()
        snapshot.appendSections([.article])
        snapshot.appendItems(Array(blocks.indices))
        snapshot.reconfigureItems(Array(blocks.indices))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func showStatus(_ status: NewsDetail.Status) {
        switch status {
            case .loading:
                collectionView?.backgroundView = UIContentUnavailableView(configuration: .loading())
            case .loaded:
                collectionView?.backgroundView = nil
            case let .failed(message):
                collectionView?.backgroundView = UIContentUnavailableView(configuration: makeConfiguration(with: message))
        }
    }
}

private extension NewsDetailViewAdapter {
    func makeDataSource(for view: UICollectionView) -> DataSource {
        let text = UICollectionView.CellRegistration<NewsDetailTextCell, NewsDetailTextCell.Item> { cell, _, item in
            cell.update(with: item)
        }
        let image = UICollectionView.CellRegistration<NewsDetailImageCell, URL> { [weak self] cell, _, url in
            cell.update(with: self?.images[url])
        }
        return DataSource(collectionView: view) { [weak self] view, indexPath, index in
            switch self?.blocks[index] {
                case let .image(url):
                    view.dequeueConfiguredReusableCell(using: image, for: indexPath, item: url)
                case let .text(attributed):
                    view.dequeueConfiguredReusableCell(using: text, for: indexPath, item: attributed)
                case nil:
                    nil
            }
        }
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
}
