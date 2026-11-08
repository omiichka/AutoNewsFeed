// StatusView.swift
// By Artem Golovanev

import Core
import UIKit

private enum Constants {
    static let numberOfLines = 2
}

public final class LoaderView: UICollectionReusableView {
    private let activityView = UIActivityIndicatorView(style: .large)
    private let messageLabel = UILabel()
    private let retryButton = UIButton(configuration: .plain())
    private var retryAction: UIAction?
    
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
    public func update(with status: State?) {
        switch status {
            case .loading:
                changeFailureViewsVisibility(true)
                activityView.startAnimating()
            case let .failed(reason):
                activityView.stopAnimating()
                messageLabel.text = reason.message
                setRetryAction(reason.action)
                changeFailureViewsVisibility(false)
            case nil:
                activityView.stopAnimating()
                changeFailureViewsVisibility(true)
        }
    }
}

extension LoaderView {
    public enum State: Equatable {
        case loading
        case failed(Reason)
    }
    
    public struct Reason: Equatable {
        let message: String
        let action: UIAction
        
        public init(
            message: String,
            action: UIAction
        ) {
            self.message = message
            self.action = action
        }
    }
}

private extension LoaderView {
    func setRetryAction(_ action: UIAction) {
        retryButton.addAction(action, for: .touchUpInside)
        retryAction = action
    }
    
    func changeFailureViewsVisibility(_ isHidden: Bool) {
        [messageLabel, retryButton].forEach { $0.isHidden = isHidden }
    }
}

private extension LoaderView {
    func setupUI() {
        messageLabel.font = UI.Typography.footnote.font()
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.textColor = UI.Color.secondaryText.color
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = Constants.numberOfLines
        
        retryButton.configuration?.title = Strings.retry
        
        changeFailureViewsVisibility(true)
    }
    
    func layout() {
        [activityView, messageLabel, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: UI.Space.l.rawValue),
            messageLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -UI.Space.xs.rawValue),
            
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: centerYAnchor, constant: UI.Space.xs.rawValue)
        ])
    }
}
