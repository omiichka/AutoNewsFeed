// DIContainer.swift
// By Artem Golovanev

import Foundation

@MainActor
public final class DIContainer {
    private var objects: [ObjectIdentifier: any Buildable] = [:]
    
    public init() {}
    
    public func register<Dependency>(
        _ type: Dependency.Type,
        _ object: some Buildable
    ) {
        objects[ObjectIdentifier(type)] = object
    }
    
    public func resolve<Dependency>(_ type: Dependency.Type = Dependency.self) -> Dependency {
        guard let object = objects[ObjectIdentifier(type)] as? Dependency else {
            preconditionFailure("\(Dependency.self) is not registered in the DI container")
        }
        return object
    }
}
