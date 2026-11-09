// Endpoint.swift
// By Artem Golovanev

import Foundation

private enum Constants {
    static let baseURL = URL(string: "https://webapi.autodoc.ru/api/")!
}

enum Endpoint {
    case news(page: Int, count: Int)
    case article(path: String)

    var url: URL {
        Constants.baseURL.appending(path: path)
    }
}

private extension Endpoint {
    var path: String {
        switch self {
            case let .news(page, count):
                "news/\(page)/\(count)"
            case let .article(path):
                "news/item/" + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        }
    }
}
