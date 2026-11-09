// NewsDetailView.swift
// By Artem Golovanev

import Core
import Design
import UIKit

private enum Constants {
    static let height: CGFloat = 200
}

final class NewsDetailView: UIView, ContentView {
    let adapter: NewsDetailViewAdapter

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    init(adapter: NewsDetailViewAdapter) {
        self.adapter = adapter
        super.init(frame: .zero)
        setupUI()
        layout()
        adapter.connect(with: collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsDetailView {
    func setupUI() {
        collectionView.backgroundColor = UI.Color.background.color
        collectionView.collectionViewLayout = compositionalLayout
        addSubview(collectionView)
    }

    func layout() {
        mapConstraint(for: collectionView)
    }
}

private extension NewsDetailView {
    var compositionalLayout: UICollectionViewLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(Constants.height))
        let layoutItem = NSCollectionLayoutItem(layoutSize: size)
        let group: NSCollectionLayoutGroup = .vertical(layoutSize: size, subitems: [layoutItem])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = UI.Space.m.rawValue
        section.contentInsetsReference = .readableContent
        section.contentInsets = .init(top: UI.Space.m.rawValue, leading: 0, bottom: UI.Space.l.rawValue, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
