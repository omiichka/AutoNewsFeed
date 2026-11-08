// ImageLoaderProtocol.swift
// By Artem Golovanev

import UIKit

public protocol ImageLoaderProtocol: Buildable, Sendable {
    func image(for url: URL) async throws -> UIImage
}
