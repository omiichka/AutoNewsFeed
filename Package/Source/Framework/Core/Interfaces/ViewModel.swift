// ViewModel.swift
// By Artem Golovanev

import Combine

@MainActor
public protocol ViewModel: AnyObject {
    associatedtype State
    associatedtype Input

    var publisher: AnyPublisher<State, Never> { get }
    func send(_ input: Input)
}
