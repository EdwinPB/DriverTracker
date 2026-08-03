// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Analytics",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "Analytics", targets: ["Analytics"]),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "Analytics",
            dependencies: ["Core"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
    ]
)
