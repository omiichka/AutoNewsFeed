// News.swift
// By Artem Golovanev

import Foundation

struct NewsPage: Hashable, Sendable {
    public let items: [News]
    public let totalCount: Int

    public init(items: [News], totalCount: Int) {
        self.items = items
        self.totalCount = totalCount
    }
}
