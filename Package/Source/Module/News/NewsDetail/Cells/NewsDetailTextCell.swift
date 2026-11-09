// NewsDetailTextCell.swift
// By Artem Golovanev

import Core
import UIKit

final class NewsDetailTextCell: UICollectionViewCell {
    private let textView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewsDetailTextCell: ContentCell {
    func update(with text: NSAttributedString) {
        textView.attributedText = text
    }
}

private extension NewsDetailTextCell {
    func setupUI() {
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = nil
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(textView)
    }

    func layout() {
        contentView.mapConstraint(for: textView)
    }
}
