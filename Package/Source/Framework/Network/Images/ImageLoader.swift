// ImageLoader.swift
// By Artem Golovanev

import Core
import UIKit

public final class ImageLoader: @unchecked Sendable {
    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
}

extension ImageLoader: ImageLoading {
    public func image(for url: URL) async throws -> UIImage {
        if let image = cache.object(forKey: url as NSURL) { return image }
        let (data, _) = try await session.data(from: url)
        guard let decoded = UIImage(data: data) else { throw ServiceError.invalidResponse }
        let image = await decoded.byPreparingForDisplay() ?? decoded
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
