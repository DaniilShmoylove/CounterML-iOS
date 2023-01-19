// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterMLKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)]
    ,
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CounterMLKit",
            targets: [
                "CounterMLKit",
                "Core",
                "CoreUI",
                "Services",
                "Resources",
            ]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "CoreUI", targets: ["CoreUI"]),
        .library(
            name: "Services",
            targets: [
                "Services",
                "Resources",
                "Core",
            ]),
        .library(name: "Resources", targets: ["Resources"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CounterMLKit",
            dependencies: []),
        .target(name: "Core"),
        .target(name: "CoreUI"),
        .target(name: "Services"),
        .target(name: "Resources"),
        .testTarget(
            name: "CounterMLKitTests",
            dependencies: ["CounterMLKit"]),
    ]
)
