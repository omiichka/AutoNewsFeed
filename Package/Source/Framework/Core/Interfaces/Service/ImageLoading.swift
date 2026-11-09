// ImageLoading.swift
// By Artem Golovanev

import UIKit

public protocol ImageLoading: Buildable, Sendable {
    func image(for url: URL) async throws -> UIImage
}
