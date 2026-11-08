// News.swift
// By Artem Golovanev

import Foundation

public struct News: Decodable, Identifiable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let category: String
    public let publishedAt: Date
    public let imageURL: URL?
    public let webURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category = "categoryType"
        case publishedAt = "publishedDate"
        case imageURL = "titleImageUrl"
        case webURL = "fullUrl"
    }
}
