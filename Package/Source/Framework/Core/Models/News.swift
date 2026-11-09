// News.swift
// By Artem Golovanev

import Foundation

public struct News: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let description: String?
    public let publishedAt: Date
    public let imageURL: URL?
    public let webURL: URL?
    public let path: String
    public let text: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case publishedAt = "publishedDate"
        case imageURL = "titleImageUrl"
        case webURL = "fullUrl"
        case path = "url"
        case text
    }
}
