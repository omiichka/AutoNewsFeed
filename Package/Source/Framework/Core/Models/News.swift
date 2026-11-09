// News.swift
// By Artem Golovanev

import Foundation

public struct News: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let summary: String?
    public let publishedAt: Date
    public let imageURL: URL?
    public let webURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case summary = "description"
        case publishedAt = "publishedDate"
        case imageURL = "titleImageUrl"
        case webURL = "fullUrl"
    }
}
