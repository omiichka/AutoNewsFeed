// ViewAdapter.swift
// By Artem Golovanev

import Combine
import UIKit

@MainActor
public protocol ViewAdapter: AnyObject {
    associatedtype State
    associatedtype Action

    var actionPublisher: AnyPublisher<Action, Never> { get }

    func connect(with collectionView: UICollectionView)
    func update(with state: State)
}
