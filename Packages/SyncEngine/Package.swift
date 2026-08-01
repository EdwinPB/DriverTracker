// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SyncEngine",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "SyncEngine", targets: ["SyncEngine"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Domain"),
        .package(path: "../Networking"),
        .package(path: "../Storage"),
    ],
    targets: [
        .target(
            name: "SyncEngine",
            dependencies: [
                "Core",
                "Domain",
                "Networking",
                "Storage",
            ]
        ),
    ]
)
