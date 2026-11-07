// ContentView.swift
// By Artem Golovanev

import UIKit

@MainActor
public protocol ContentView: AnyObject {
    associatedtype Adapter: ViewAdapter

    var adapter: Adapter { get }
}
