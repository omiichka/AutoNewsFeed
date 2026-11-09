// NewsFeedView.swift
// By Artem Golovanev

import Core
import Design
import UIKit

private enum Constants {
    static let minCardWidth: CGFloat = 280
}

final class NewsFeedView: UIView, ContentView {
    let adapter: NewsFeedViewAdapter

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    init(adapter: NewsFeedViewAdapter) {
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

private extension NewsFeedView {
    func setupUI() {
        collectionView.backgroundColor = UI.Color.background.color
        collectionView.refreshControl = UIRefreshControl()
        collectionView.collectionViewLayout = compositionalLayout
        addSubview(collectionView)
    }

    func layout() {
        mapConstraint(for: collectionView)
    }
}

private extension NewsFeedView {
    var compositionalLayout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] _, environment in
            guard let self else { return nil }
            let traits = environment.traitCollection
            let padding = padding(for: traits)
            let width = contentWidth(in: environment, padding: padding)
            let columns = columnCount(for: width)
            let cardWidth = (width - UI.Space.m.rawValue * CGFloat(columns - 1)) / CGFloat(columns)
            let cardHeight = NewsFeedCell.height(forWidth: cardWidth, traits: traits)
            let layoutGroup = group(count: columns, width: cardWidth, height: cardHeight)
            let section = NSCollectionLayoutSection(group: layoutGroup)
            section.interGroupSpacing = UI.Space.m.rawValue
            section.contentInsetsReference = .safeArea
            section.contentInsets = .init(top: UI.Space.m.rawValue, leading: padding, bottom: 0, trailing: padding)
            section.boundarySupplementaryItems = [footer]
            return section
        }
    }

    func padding(for traits: UITraitCollection) -> CGFloat {
        traits.horizontalSizeClass == .regular ? UI.Space.l.rawValue : UI.Space.m.rawValue
    }

    func contentWidth(in environment: any NSCollectionLayoutEnvironment, padding: CGFloat) -> CGFloat {
        let safeArea = collectionView.safeAreaInsets
        return environment.container.effectiveContentSize.width - safeArea.left - safeArea.right - 2 * padding
    }

    func columnCount(for width: CGFloat) -> Int {
        let spacing = UI.Space.m.rawValue
        return max(1, Int((width + spacing) / (Constants.minCardWidth + spacing)))
    }

    func group(count: Int, width: CGFloat, height: CGFloat) -> NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
        let group: NSCollectionLayoutGroup = .horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: count
        )
        group.interItemSpacing = .fixed(UI.Space.m.rawValue)
        return group
    }

    var footer: NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(UI.Space.l.rawValue))
        let elementKind = UICollectionView.elementKindSectionFooter
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize,
            elementKind: elementKind,
            alignment: .bottom
        )
    }
}
