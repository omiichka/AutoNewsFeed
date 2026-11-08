// PlaceholderImageView.swift
// By Artem Golovanev

import Core
import UIKit

public final class ImageView: UIImageView {
    public init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageView: ContentCell {
    public func update(with image: UIImage?) {
        self.image = image ?? UI.Icon.newspaper.image
        contentMode = image == nil ? .center : .scaleAspectFill
    }
}

private extension ImageView {
    func setupUI() {
        backgroundColor = UI.Color.imageBackground.color
        clipsToBounds = true
        tintColor = UI.Color.placeholder.color
        preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        update(with: nil)
    }
}
