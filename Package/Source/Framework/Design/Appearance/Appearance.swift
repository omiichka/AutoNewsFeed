// Appearance.swift
// By Artem Golovanev

import Core
import UIKit

public enum Appearance: String, CaseIterable {
    case system
    case light
    case dark
    
    public var title: String {
        switch self {
            case .system: Strings.appearanceSystem
            case .light: Strings.appearanceLight
            case .dark: Strings.appearanceDark
        }
    }
    
    public var image: UIImage? {
        switch self {
            case .system: UI.Icon.gear.image
            case .light: UI.Icon.sun.image
            case .dark: UI.Icon.moon.image
        }
    }
    
    public var style: UIUserInterfaceStyle {
        switch self {
            case .system: .unspecified
            case .light: .light
            case .dark: .dark
        }
    }
}
