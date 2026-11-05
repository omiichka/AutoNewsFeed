// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v17)],
    products: .products,
    targets: .targets,
    swiftLanguageModes: [.v6]
)

private enum Framework: String, CaseIterable {
    case core = "Core"
    case network = "Network"
    case design = "Design"
    
    var target: Target {
        .target(
            name: rawValue,
            dependencies: [],
            path: "Source/Framework/\(rawValue)"
        )
    }
}

private enum Module: String, CaseIterable {
    case newsFeed = "NewsFeed"

    var dependencies: [Target.Dependency] {
        switch self {
        case .newsFeed: .frameworks(.core, .network, .design)
        }
    }
    
    var target: Target {
        .target(
            name: rawValue,
            dependencies: dependencies,
            path: "Source/Module/\(rawValue)"
        )
    }

    var product: Product {
        .library(
            name: rawValue,
            targets: [rawValue]
        )
    }
}

private extension Array where Element == Target.Dependency {
    static func frameworks(_ frameworks: Framework...) -> Self {
        frameworks.map { .target(name: $0.rawValue) }
    }
}

private extension Array where Element == Product {
    static var products: [Product] {
        Module.allCases.map(\.product)
    }
}

private extension Array where Element == Target {
    static var targets: [Target] {
        Framework.allCases.map(\.target) + Module.allCases.map(\.target)
    }
}
