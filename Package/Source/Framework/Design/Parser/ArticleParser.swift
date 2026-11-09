// ArticleParser.swift
// By Artem Golovanev

import Core
import UIKit

private enum Constants {
    static let attributes: [NSAttributedString.Key: Any] = [.font: UI.Typography.body.font(), .foregroundColor: UI.Color.text.color]
}

public struct ArticleParser: ArticleParsing {
    private let imageTag = /<img[^>]*?src\s*=\s*"(?<url>[^"]+)"[^>]*>/.ignoresCase()
    
    public init() {}
    
    public func blocks(for article: News) -> [ArticleBlock] {
        let html = article.text ?? ""
        let topImage = html.contains(imageTag) ? [] : imageBlock(for: article.imageURL)
        return [.text(headline(for: article))] + topImage + blocks(from: html)
    }
}

private extension ArticleParser {
    func blocks(from html: String) -> [ArticleBlock] {
        var blocks: [ArticleBlock] = []
        var textStart = html.startIndex
        for tag in html.matches(of: imageTag) {
            blocks += textBlock(from: html[textStart..<tag.range.lowerBound])
            blocks += imageBlock(for: URL(string: String(tag.url)))
            textStart = tag.range.upperBound
        }
        blocks += textBlock(from: html[textStart...])
        return blocks
    }
    
    func imageBlock(for url: URL?) -> [ArticleBlock] {
        guard let url else { return [] }
        return [.image(url)]
    }
    
    func textBlock(from html: Substring) -> [ArticleBlock] {
        guard let text = styledText(from: String(html)) else { return [] }
        return [.text(text)]
    }
    
    func styledText(from html: String) -> NSAttributedString? {
        guard let text = try? NSMutableAttributedString(
            data: Data(html.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ), !text.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        
        text.addAttributes(Constants.attributes, range: NSRange(location: 0, length: text.length))
        trimTrailingNewlines(of: text)
        return text
    }
    
    func trimTrailingNewlines(of text: NSMutableAttributedString) {
        while text.string.last?.isNewline == true {
            text.deleteCharacters(in: NSRange(location: text.length - 1, length: 1))
        }
    }
    
    func headline(for article: News) -> NSAttributedString {
        let attributedString = NSAttributedString(
            string: "\n" + article.publishedAt.formatted(date: .numeric, time: .omitted),
            attributes: [.font: UI.Typography.subheadline.font(), .foregroundColor: UI.Color.secondaryText.color]
        )
        let headline = NSMutableAttributedString(
            string: article.title,
            attributes: Constants.attributes
        )
        headline.append(attributedString)
        return headline
    }
}
