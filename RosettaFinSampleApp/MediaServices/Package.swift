// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MediaServices",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MediaServices",
            targets: ["MediaServices"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/jellyfin/jellyfin-sdk-swift.git",
            from: "0.5.1"),
        .package(path: "DataModels")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MediaServices",
            dependencies: [
                .product(
                    name: "JellyfinAPI",
                    package: "jellyfin-sdk-swift"
                ),
                .product(name: "DataModels", package: "DataModels")
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        
        .testTarget(
            name: "MediaServicesTests",
            dependencies: ["MediaServices"]
        )
    ]
)
