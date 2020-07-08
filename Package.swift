// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Http",
    platforms: [.macOS(.v10_12), .iOS(.v8)],
    products: [.library(name: "Http", targets: ["Http"])],
    dependencies: [
        .package(url: "https://github.com/Balancingrock/Ascii", from: "1.4.0")
    ],
    targets: [ .target( name: "Http", dependencies: ["Ascii"]) ],
    swiftLanguageVersions: [.v4, .v4_2, .v5]
)
