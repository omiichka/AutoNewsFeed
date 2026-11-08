// Strings.swift
// By Artem Golovanev

import Foundation

public enum Strings {
    public static var feedTitle: String { String(localized: "feed.title", bundle: .module) }
    public static var retry: String { String(localized: "retry", bundle: .module) }
    public static var appearanceTitle: String { String(localized: "appearance.title", bundle: .module) }
    public static var appearanceSystem: String { String(localized: "appearance.system", bundle: .module) }
    public static var appearanceLight: String { String(localized: "appearance.light", bundle: .module) }
    public static var appearanceDark: String { String(localized: "appearance.dark", bundle: .module) }
    public static var invalidResponse: String { String(localized: "error.invalidResponse", bundle: .module) }

    public static func serverError(_ code: Int) -> String {
        String(localized: "error.status \(code)", bundle: .module)
    }
}
