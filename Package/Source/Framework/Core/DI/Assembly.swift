// Assembly.swift
// By Artem Golovanev

import Foundation

@MainActor
public protocol Assembly {
    func assemble(container: DIContainer)
}
