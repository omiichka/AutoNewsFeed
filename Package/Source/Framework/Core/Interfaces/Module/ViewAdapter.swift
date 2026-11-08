// ViewAdapter.swift
// By Artem Golovanev

import Combine
import UIKit

@MainActor
public protocol ViewAdapter: Observable {
    associatedtype State

    func connect(with collectionView: UICollectionView)
    func update(with state: State)
}
