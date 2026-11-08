// Coordinator.swift
// By Artem Golovanev

import UIKit

@MainActor
public protocol Coordinator: Buildable {
    var navigationController: UINavigationController { get }

    func start()
}
