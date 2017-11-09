// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Coverability",
    dependencies: [
        .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Coverability",
            dependencies: ["CoverabilityLib"]),
        .target(
            name: "CoverabilityLib",
            dependencies: ["PetriKit"]),
        .testTarget(
            name: "CoverabilityLibTests",
            dependencies: ["CoverabilityLib"]),
    ]
)
