// ImageLoader.swift
// By Artem Golovanev

import UIKit

public protocol ImageLoaderProtocol: Sendable {
    func cachedImage(for url: URL, maxPixelSize: CGFloat) -> UIImage?
    func image(for url: URL, maxPixelSize: CGFloat) async throws -> UIImage
}
