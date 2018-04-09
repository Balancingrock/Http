// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Http",
    products: [
        .library(name: "Http", targets: ["Http"])
    ],
    dependencies: [
        .package(url: "https://github.com/Balancingrock/Ascii", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "Http",
            dependencies: ["Ascii"]
        )
    ]
)
