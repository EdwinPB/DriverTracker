// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Testing",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Testing", targets: ["Testing"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
    ],
    targets: [
        .target(
            name: "Testing",
            dependencies: [
                "Core",
                "Domain",
            ]
        ),
    ]
)
