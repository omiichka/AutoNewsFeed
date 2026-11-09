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
        case gear
        case sun
        case moon
        case newspaper
        case nosign
        
        public var image: UIImage? {
            UIImage(systemName: self.name)
        }
    }
}

private extension UI.Icon {
    var name: String {
        switch self {
            case .gear:
                "gear"
            case .sun:
                "sun.max"
            case .moon:
                "moon"
            case .newspaper:
                "newspaper"
            case .nosign:
                "nosign"
        }
    }
}

public extension UI {
    enum Typography {
        case headline
        case subheadline
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
            case .headline:
                    .headline
            case .subheadline:
                    .subheadline
            case .caption:
                    .caption1
        }
    }
}

public extension UI {
    enum Color {
        case background
        case cardBackground
        case imageBackground
        case secondaryText
        case placeholder

        public var color: UIColor {
            switch self {
                case .background:
                    .systemGroupedBackground
                case .cardBackground:
                    .secondarySystemGroupedBackground
                case .imageBackground:
                    .tertiarySystemFill
                case .secondaryText:
                    .secondaryLabel
                case .placeholder:
                    .tertiaryLabel
            }
        }
    }
}
