// AppearanceStore.swift
// By Artem Golovanev

import Foundation

public struct AppearanceStore {
    private static let key = "AppearanceStoreKey"
    private let userDefaults: UserDefaults

    public init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public var current: Appearance {
        get {
            userDefaults
            .string(forKey: Self.key)
            .flatMap(Appearance.init(rawValue:))
            ?? .system
        }
        nonmutating set {
            userDefaults
            .set(
                newValue.rawValue,
                forKey: Self.key
            )
        }
    }
}
