// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "KaseyHTTP",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(
            name: "KaseyHTTP",
            targets: ["KaseyHTTP"]
        ),
    ],
    targets: [
        .target(
            name: "KaseyHTTP"
        ),
        .testTarget(
            name: "KaseyHTTPTests",
            dependencies: ["KaseyHTTP"]
        ),
    ]
)
