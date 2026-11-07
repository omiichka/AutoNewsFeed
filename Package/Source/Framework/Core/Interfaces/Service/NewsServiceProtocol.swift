// NewsServiceProtocol.swift
// By Artem Golovanev

import Foundation

public protocol NewsServiceProtocol: Buildable, Sendable {
    func fetchNews(page: Int, count: Int) async throws -> NewsPage
}
