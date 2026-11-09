// NewsDetail.swift
// By Artem Golovanev

import Core
import UIKit

struct NewsDetail {}

extension NewsDetail {
    nonisolated enum Section: Hashable, Sendable {
        case article
    }

    enum Action {
        case load
        case loadImage(URL)
    }

    struct State {
        var blocks: [ArticleBlock] = []
        var images: [URL: UIImage] = [:]
        var status: Status = .loading
    }

    enum Status: Equatable {
        case loading
        case loaded
        case failed(String)
    }
}
