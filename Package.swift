// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "ReviewKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ReviewKit",
            targets: ["ReviewKit"]),
    ],
    dependencies: [
        // .package(url: "https://github.com/gitmart-co/gitmart-ios-sdk", from: "0.0.1")
        .package(path: "../GitMart")
    ],
    targets: [
        .target(
            name: "ReviewKit",
            dependencies: [
                // .product(name: "GitMart", package: "gitmart-ios-sdk")
                "GitMart"
            ]
        )
    ]
)
