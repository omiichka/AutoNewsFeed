// NewsFeedCell.swift
// By Artem Golovanev

import Core
import Design
import UIKit

private enum Constants {
    static let multiplier = 1 / UI.Ratio.photo.rawValue
    static let titleLines = 3
    static let descriptionLines = 2
}

final class NewsFeedCell: UICollectionViewCell {
    private let imageView = ImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
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
        let image = width / UI.Ratio.photo.rawValue
        let text = UI.Space.s.rawValue + title * CGFloat(Constants.titleLines) + UI.Space.xs.rawValue + summary * CGFloat(Constants.descriptionLines) + UI.Space.xs.rawValue + date + UI.Space.s.rawValue
        return (image + text).rounded(.up)
    }
}

extension NewsFeedCell: ContentCell {
    func update(with item: (news: News, image: UIImage?)) {
        titleLabel.text = item.news.title
        descriptionLabel.text = item.news.description
        dateLabel.text = item.news.publishedAt.formatted(date: .numeric, time: .omitted)
        imageView.update(with: item.image)
    }
}

private extension NewsFeedCell {
    func setupUI() {
        contentView.backgroundColor = UI.Color.cardBackground.color
        contentView.layer.cornerRadius = UI.Radius.card.rawValue
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        titleLabel.font = UI.Typography.headline.font()
        titleLabel.numberOfLines = Constants.titleLines

        descriptionLabel.font = UI.Typography.subheadline.font()
        descriptionLabel.textColor = UI.Color.secondaryText.color
        descriptionLabel.numberOfLines = Constants.descriptionLines

        dateLabel.font = UI.Typography.caption.font()
        dateLabel.textColor = UI.Color.secondaryText.color

        [titleLabel, descriptionLabel].forEach {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        }
        [titleLabel, descriptionLabel, dateLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
        }
        
        [imageView, titleLabel, descriptionLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.multiplier),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UI.Space.s.rawValue),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.Space.m.rawValue),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.Space.m.rawValue),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: UI.Space.xs.rawValue),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.Space.m.rawValue),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.Space.m.rawValue),
            
            dateLabel.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: UI.Space.xs.rawValue),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UI.Space.s.rawValue),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UI.Space.m.rawValue),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UI.Space.m.rawValue)
        ])
    }
}
