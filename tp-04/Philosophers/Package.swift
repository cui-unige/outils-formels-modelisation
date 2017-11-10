// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Philosophers",
    dependencies: [
        .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "1.0.0"),
        .package(url: "https://github.com/kyouko-taiga/SwiftProductGenerator.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Philosophers",
            dependencies: ["PhilosophersLib"]),
        .target(
            name: "PhilosophersLib",
            dependencies: ["PetriKit", "SwiftProductGenerator"]),
        .testTarget(
            name: "PhilosophersLibTests",
            dependencies: ["PhilosophersLib"]),
    ]
)
