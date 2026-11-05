// ViewModel.swift
// By Artem Golovanev
	

import Combine

protocol ViewModel: AnyObject {
    associatedtype State
    associatedtype Input
    
    var publisher: AnyPublisher<State, Never> { get }
    func send(_ input: Input)
}
