// ContentView.swift
// By Artem Golovanev
	

import Combine

protocol ContentView: AnyObject {
    associatedtype State
    associatedtype Action
    
    var publisher: AnyPublisher<Action, Never> { get }
    func render(_ state: State)
}
