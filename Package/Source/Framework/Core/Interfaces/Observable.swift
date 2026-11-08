// Observer.swift
// By Artem Golovanev

import Combine

@MainActor
public protocol Observable: AnyObject {
    associatedtype Item
    associatedtype Subject: Combine.Subject where Subject.Output == Item, Subject.Failure == Never

    var subject: Subject { get }
}

public extension Observable {
    var publisher: AnyPublisher<Item, Never> {
        subject.eraseToAnyPublisher()
    }
}
