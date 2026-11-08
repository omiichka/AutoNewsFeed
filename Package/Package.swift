// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v17)],
    products: Module.allCases.map(\.product),
    targets: Framework.allCases.map(\.target) + Module.allCases.map(\.target),
    swiftLanguageModes: [.v6]
)

private enum Framework: String, CaseIterable {
    case core = "Core"
    case network = "Network"
    case design = "Design"
    
    var target: Target {
        .target(
            name: rawValue,
            dependencies: dependencies,
            path: "Source/Framework/\(rawValue)",
            resources: resources,
            swiftSettings: swiftSettings
        )
    }
}

extension Framework {
    var dependencies: [Target.Dependency] {
        switch self {
            case .core: []
            case .network, .design: .frameworks(.core)
        }
    }
    
    var resources: [Resource] {
        switch self {
            case .core: .stringCatalog
            case .network, .design: []
        }
    }
    
    var swiftSettings: [SwiftSetting] {
        switch self {
            case .core, .network: []
            case .design: .mainActor
        }
    }
}

private enum Module: String, CaseIterable {
    case newsFeed = "News"
    
    var target: Target {
        .target(
            name: rawValue,
            dependencies: dependencies,
            path: "Source/Module/\(rawValue)",
            swiftSettings: .mainActor
        )
    }
    
    var product: Product {
        .library(
            name: rawValue,
            targets: [rawValue]
        )
    }
}

extension Module {
    var dependencies: [Target.Dependency] {
        switch self {
            case .newsFeed: .frameworks(.core, .design, .network)
        }
    }
}

private extension Array where Element == Target.Dependency {
    static func frameworks(_ frameworks: Framework...) -> Self {
        frameworks.map { .target(name: $0.rawValue) }
    }
}

private extension Array where Element == Resource {
    static var stringCatalog: Self {
        [.process("Resources")]
    }
}

private extension Array where Element == SwiftSetting {
    static var mainActor: Self {
        [.defaultIsolation(MainActor.self)]
    }
}
