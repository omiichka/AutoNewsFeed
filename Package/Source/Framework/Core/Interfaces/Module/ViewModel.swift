// ViewModel.swift
// By Artem Golovanev

import Foundation

@MainActor
public protocol ViewModel: Observable {
    associatedtype Input

    func send(_ input: Input)
}
