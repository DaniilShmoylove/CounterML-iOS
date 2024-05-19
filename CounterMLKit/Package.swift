// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterMLKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    
    //MARK: - Products
    
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CounterMLKit",
            targets: [
                "CounterMLKit",
                "Core",
                "CoreUI",
                "Services",
                "SharedModels",
                "Helpers",
                "Authentication"
            ]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(
            name: "Authentication",
            targets: [
                "Services",
                "SharedModels",
                "CoreUI",
                "Helpers",
            ]),
        .library(
            name: "Services",
            targets: [
                "Services",
                "SharedModels",
                "Core",
                "Helpers"
            ]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "Helpers", targets: ["Helpers", "Services"]),
    ],
    
    //MARK: - Dependencies
    
    dependencies: [
        
        /// An ultralight Dependency Injection / Service Locator framework for Swift 5.x on iOS.
        
        .package(
            url: "https://github.com/hmlongco/Resolver",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS",
            from: "7.1.0"
        )
    ],
    
    //MARK: - Targets
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CounterMLKit",
            dependencies: [
                "Core",
                "CoreUI",
                "Services",
                "SharedModels",
                "Helpers",
                "Authentication",
                .product(name: "Resolver", package: "Resolver"),
            ]),
        .target(name: "Core"),
        .target(name: "CoreUI"),
        .target(
            name: "Services",
            dependencies: [
                .product(name: "Resolver", package: "Resolver"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
            ]),
        .target(name: "SharedModels"),
        .target(name: "Helpers", dependencies: [
            "Services",
            "SharedModels",
            .product(name: "Resolver", package: "Resolver"),
        ]),
        .target(name: "Authentication", dependencies: [
            "Services",
            "SharedModels",
            "CoreUI",
            "Helpers",
            .product(name: "Resolver", package: "Resolver"),
        ]),
        .testTarget(
            name: "CounterMLKitTests",
            dependencies: ["CounterMLKit"]),
    ]
)
