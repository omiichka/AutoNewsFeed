// NewsFetching.swift
// By Artem Golovanev

import Foundation

public protocol NewsFetching: Buildable, Sendable {
    func fetchNews(page: Int, count: Int) async throws -> NewsPage
}
