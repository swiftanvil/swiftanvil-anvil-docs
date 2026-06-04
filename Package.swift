// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AnvilDocs",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "AnvilDocs", targets: ["AnvilDocs"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "AnvilDocs",
            dependencies: [
                .product(name: "Yams", package: "Yams"),
            ]
        ),
        .testTarget(
            name: "AnvilDocsTests",
            dependencies: ["AnvilDocs"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
