// ViewModel.swift
// By Artem Golovanev

import Combine

@MainActor
public protocol ViewModel: Observable {
    associatedtype Input

    func send(_ input: Input)
}
