import PackageDescription

let package = Package(
    name: "Http",
    dependencies: [
        .Package(url: "https://github.com/Balancingrock/Ascii", Version(1, 0, 0))
    ]
)
