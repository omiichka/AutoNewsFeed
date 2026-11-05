// Article.swift
// By Artem Golovanev

import Foundation

public struct Article: Hashable, Sendable {
    public let news: News
    public let html: String

    public init(news: News, html: String) {
        self.news = news
        self.html = html
    }
}
