// LoaderView.swift
// By Artem Golovanev

import Core
import UIKit

public final class LoaderView: UICollectionReusableView {
    private let activityView = UIActivityIndicatorView(style: .large)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoaderView: ContentCell {
    public func update(with isLoading: Bool) {
        isLoading ? activityView.startAnimating() : activityView.stopAnimating()
    }
}

private extension LoaderView {
    func setupUI() {
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityView)
    }

    func layout() {
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityView.topAnchor.constraint(equalTo: topAnchor, constant: UI.Space.m.rawValue),
            activityView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -UI.Space.m.rawValue)
        ])
    }
}
