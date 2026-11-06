// NewsPage.swift
// By Artem Golovanev

import Foundation

public struct NewsPage: Decodable, Sendable {
    public let items: [News]
    public let totalCount: Int

    public init(items: [News], totalCount: Int) {
        self.items = items
        self.totalCount = totalCount
    }

    enum CodingKeys: String, CodingKey {
        case items = "news"
        case totalCount
    }
}
