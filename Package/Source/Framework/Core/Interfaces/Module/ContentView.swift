// ContentView.swift
// By Artem Golovanev

import Foundation

@MainActor
public protocol ContentView: AnyObject {
    associatedtype Adapter: ViewAdapter
    
    var adapter: Adapter { get }
}
