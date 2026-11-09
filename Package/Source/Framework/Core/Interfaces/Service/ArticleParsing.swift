// ArticleParsing.swift
// By Artem Golovanev

import Foundation

@MainActor
public protocol ArticleParsing: Buildable {
    func blocks(for article: News) -> [ArticleBlock]
}
