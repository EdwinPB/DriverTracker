// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Location",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Location", targets: ["Location"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Location",
            dependencies: [
                "Core",
                "Domain",
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
    ]
)
