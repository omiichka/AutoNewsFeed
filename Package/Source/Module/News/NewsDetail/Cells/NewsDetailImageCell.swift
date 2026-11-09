// NewsDetailImageCell.swift
// By Artem Golovanev

import Core
import Design
import UIKit

private enum Constants {
    static let multiplier = 1 / UI.Ratio.photo.rawValue
}

final class NewsDetailImageCell: UICollectionViewCell {
    private let imageView = ImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsDetailImageCell: ContentCell {
    func update(with image: UIImage?) {
        imageView.update(with: image)
    }
}

private extension NewsDetailImageCell {
    func setupUI() {
        contentView.layer.cornerRadius = UI.Radius.card.rawValue
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    func layout() {
        contentView.mapConstraint(for: imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.multiplier)
        ])
    }
}
