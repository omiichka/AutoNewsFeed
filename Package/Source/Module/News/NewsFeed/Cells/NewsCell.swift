// NewsCell.swift
// By Artem Golovanev

import Core
import Design
import UIKit

private enum Constants {
    static let aspectRatio: CGFloat = 3 / 2
    static let titleLines = 3
    static let summaryLines = 2
}

final class NewsCell: UICollectionViewCell {
    private let imageView = ImageView()
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func height(
        forWidth width: CGFloat,
        traits: UITraitCollection
    ) -> CGFloat {
        let title = UI.Typography.headline.font(compatibleWith: traits).lineHeight
        let summary = UI.Typography.subheadline.font(compatibleWith: traits).lineHeight
        let date = UI.Typography.caption.font(compatibleWith: traits).lineHeight
        let image = width / Constants.aspectRatio
        let text = UI.Space.s.rawValue + title * CGFloat(Constants.titleLines) + UI.Space.xs.rawValue + summary * CGFloat(Constants.summaryLines) + UI.Space.xs.rawValue + date + UI.Space.s.rawValue
        return (image + text).rounded(.up)
    }
}

extension NewsCell: ContentCell {
    func update(with item: (news: News, image: UIImage?)) {
        titleLabel.text = item.news.title
        summaryLabel.text = item.news.summary
        dateLabel.text = item.news.publishedAt.formatted(date: .numeric, time: .omitted)
        imageView.update(with: item.image)
    }
}

private extension NewsCell {
    func setupUI() {
        contentView.backgroundColor = UI.Color.cardBackground.color
        contentView.layer.cornerRadius = UI.Radius.card.rawValue
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        titleLabel.font = UI.Typography.headline.font()
        titleLabel.numberOfLines = Constants.titleLines

        summaryLabel.font = UI.Typography.subheadline.font()
        summaryLabel.textColor = UI.Color.secondaryText.color
        summaryLabel.numberOfLines = Constants.summaryLines

        dateLabel.font = UI.Typography.caption.font()
        dateLabel.textColor = UI.Color.secondaryText.color

        [titleLabel, summaryLabel].forEach {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
        [titleLabel, summaryLabel, dateLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
        }
    }

    func layout() {
        [imageView, titleLabel, summaryLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / Constants.aspectRatio),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UI.Space.s.rawValue),
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UI.Space.xs.rawValue),
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: summaryLabel.bottomAnchor, constant: UI.Space.xs.rawValue),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UI.Space.s.rawValue)
        ])
        [titleLabel, summaryLabel, dateLabel].forEach {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.Space.m.rawValue),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.Space.m.rawValue)
            ])
        }
    }
}
