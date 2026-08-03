// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Authentication",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Authentication", targets: ["Authentication"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../Networking"),
    ],
    targets: [
        .target(
            name: "Authentication",
            dependencies: [
                "Core",
                "Domain",
                "Networking",
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
    ]
)
