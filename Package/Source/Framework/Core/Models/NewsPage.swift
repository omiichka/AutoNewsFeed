// NewsPage.swift
// By Artem Golovanev

import Foundation

public struct NewsPage: Decodable, Sendable {
    public let items: [News]
    public let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case items = "news"
        case totalCount
    }
}
