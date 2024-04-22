// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Visually",
    products: [
        .library(
            name: "Visually",
            targets: ["Visually"]),
    ],
    targets: [
        .target(
            name: "Visually"),
        .testTarget(
            name: "VisuallyTests",
            dependencies: ["Visually"]),
    ]
)
