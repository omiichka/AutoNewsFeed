// News.swift
// By Artem Golovanev

import Foundation

public struct News: Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let summary: String
    public let category: String
    public let publishedAt: Date
    public let imageURL: URL?
    public let slug: String
    public let webURL: URL?

    public init(
        id: Int,
        title: String,
        summary: String,
        category: String,
        publishedAt: Date,
        imageURL: URL?,
        slug: String,
        webURL: URL?
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.category = category
        self.publishedAt = publishedAt
        self.imageURL = imageURL
        self.slug = slug
        self.webURL = webURL
    }
}

public struct NewsPage: Hashable, Sendable {
    public let items: [News]
    public let totalCount: Int

    public init(items: [News], totalCount: Int) {
        self.items = items
        self.totalCount = totalCount
    }
}

public struct Article: Hashable, Sendable {
    public let news: News
    public let html: String

    public init(news: News, html: String) {
        self.news = news
        self.html = html
    }
}
