// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TaskManager",
    dependencies: [
        .package(url: "https://github.com/kyouko-taiga/PetriKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TaskManager",
            dependencies: ["TaskManagerLib"]),
        .target(
            name: "TaskManagerLib",
            dependencies: ["PetriKit"]),
        .testTarget(
            name: "TaskManagerLibTests",
            dependencies: ["TaskManagerLib"]),
    ]
)
