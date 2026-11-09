// NewsService.swift
// By Artem Golovanev

import Core
import Foundation

private enum Constants {
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let dateLocale = Locale(identifier: "ru_RU")
}

public struct NewsService: NewsFetching {
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(session: URLSession = .shared) {
        let formatter = DateFormatter()
        formatter.locale = Constants.dateLocale
        formatter.dateFormat = Constants.dateFormat
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)

        self.session = session
        self.decoder = decoder
    }

    public func fetchNews(page: Int, count: Int) async throws -> NewsPage {
        try await fetch(.news(page: page, count: count))
    }

    public func fetchArticle(path: String) async throws -> News {
        try await fetch(.article(path: path))
    }
}

private extension NewsService {
    func fetch<Response: Decodable>(_ endpoint: Endpoint) async throws -> Response {
        let (data, response) = try await session.data(from: endpoint.url)
        guard let response = response as? HTTPURLResponse else { throw ServiceError.invalidResponse }
        guard 200..<300 ~= response.statusCode else { throw ServiceError.requestError(response.statusCode) }
        return try decoder.decode(Response.self, from: data)
    }
}
