// UI.swift
// By Artem Golovanev

import UIKit

public struct UI {}

public extension UI {
    enum Radius: CGFloat {
        case card = 18
    }
}

public extension UI {
    enum Space: CGFloat {
        case xs = 8
        case s = 12
        case m = 16
        case l = 24
    }
}

public extension UI {
    enum Icon {
        case circle
        case sun
        case moon
        case newspaper
        case warning
        
        public var image: UIImage? {
            UIImage(systemName: self.name)
        }
    }
}

private extension UI.Icon {
    var name: String {
        switch self {
            case .circle:
                "circle.lefthalf.filled"
            case .sun:
                "sun.max"
            case .moon:
                "moon"
            case .newspaper:
                "newspaper"
            case .warning:
                "exclamationmark.triangle"
        }
    }
}

public extension UI {
    enum Typography {
        case largeTitle
        case headline
        case subheadline
        case footnote
        case caption
        
        public func font(compatibleWith: UITraitCollection? = nil) -> UIFont {
            .preferredFont(
                forTextStyle: style,
                compatibleWith: compatibleWith
            )
        }
    }
}

extension UI.Typography {
    private var style: UIFont.TextStyle {
        switch self {
            case .largeTitle:
                    .largeTitle
            case .headline:
                    .headline
            case .subheadline:
                    .subheadline
            case .footnote:
                    .footnote
            case .caption:
                    .caption1
        }
    }
}

public extension UI {
    enum Color {
        case background
        case groupedBackground
        case cardBackground
        case imageBackground
        case clear
        case accent
        case secondaryText
        case placeholder
        case overlayText
        case overlaySecondaryText
        case gradientStart
        case gradientEnd

        public var color: UIColor {
            switch self {
                case .background:
                    .systemBackground
                case .groupedBackground:
                    .systemGroupedBackground
                case .cardBackground:
                    .secondarySystemGroupedBackground
                case .imageBackground:
                    .tertiarySystemFill
                case .clear:
                    .clear
                case .accent:
                    .tintColor
                case .secondaryText:
                    .secondaryLabel
                case .placeholder:
                    .tertiaryLabel
                case .overlayText:
                    .white
                case .overlaySecondaryText:
                    .white.withAlphaComponent(0.8)
                case .gradientStart:
                    .black.withAlphaComponent(0)
                case .gradientEnd:
                    .black.withAlphaComponent(0.75)
            }
        }
    }
}
