// NewsService.swift
// By Artem Golovanev

import Foundation

public protocol NewsServiceProtocol: Sendable {
    func fetchNews(page: Int, count: Int) async throws -> NewsPage
    func fetchArticle(path: String) async throws -> Article
}
