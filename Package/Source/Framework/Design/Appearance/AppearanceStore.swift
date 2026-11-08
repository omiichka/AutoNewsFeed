// AppearanceStore.swift
// By Artem Golovanev

import Combine
import Core
import Foundation

public final class AppearanceStore: Buildable, Observable {
    private static let key = "AppearanceStoreKey"
    private let userDefaults: UserDefaults
    public let subject: CurrentValueSubject<Appearance, Never>

    public init(with userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        subject = CurrentValueSubject(
            userDefaults
                .string(forKey: Self.key)
                .flatMap(Appearance.init(rawValue:))
            ?? .system
        )
    }

    public var current: Appearance {
        get {
            subject.value
        }
        set {
            userDefaults
                .set(
                    newValue.rawValue,
                    forKey: Self.key
                )
            subject.send(newValue)
        }
    }
}
