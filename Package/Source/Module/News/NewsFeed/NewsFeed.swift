// NewsFeed.swift
// By Artem Golovanev

import Core
import UIKit

nonisolated struct NewsFeed {}

nonisolated extension NewsFeed {
    enum Section: Hashable, Sendable {
        case news
    }

    enum Action {
        case loadMore
        case refresh
        case select(News)
        case loadImage(News)
    }

    struct State: Equatable {
        var items: [News] = []
        var status: Status = .idle
        var images: [News: UIImage] = [:]
    }

    enum Status: Equatable {
        case idle
        case loading
        case refreshing
        case failed(String)
        case allLoaded
    }
}
