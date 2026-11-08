// GradientView.swift
// By Artem Golovanev

import UIKit

public final class GradientView: UIView {
    public override class var layerClass: AnyClass { CAGradientLayer.self }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension GradientView {
    func setupUI() {
        isUserInteractionEnabled = false
        guard let gradient = layer as? CAGradientLayer else { return }
        gradient.colors = [UI.Color.gradientStart.color.cgColor, UI.Color.gradientEnd.color.cgColor]
    }
}
