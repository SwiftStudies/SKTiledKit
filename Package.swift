// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SKTiledKit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SKTiledKit",
            targets: ["SKTiledKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/SwiftStudies/TiledKit.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SKTiledKit",
            dependencies: ["TiledKit"]),
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
