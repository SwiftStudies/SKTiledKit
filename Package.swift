// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SKTiledKit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SKTiledKit",
            targets: ["SKTiledKit"]),
        .executable(
            name: "sktiled",
            targets: ["SKTiled"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftStudies/TiledKit", from: "0.0.8"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SKTiledKit",
            dependencies: ["TiledKit"]),
        .target(
            name: "SKTiled",
            dependencies: ["SKTiledKit",.product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .testTarget(
            name: "SKTiledKitTests",
            dependencies: ["SKTiledKit"],
            exclude: [
                "Resources/PikoPixel",
                "Resources/Test Project.tiled-session"
            ],
            resources: [
                .copy("Resources/Test Project.tiled-project"),
                .copy("Resources/Maps"),
                .copy("Resources/Tilesets"),
                .copy("Resources/Images")]
        )
    ]
)
