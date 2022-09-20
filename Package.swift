// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "ChatKit",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ChatKit",
            targets: ["ChatKit"]),
    ],
    dependencies: [
         .package(url: "https://github.com/gitmart-co/gitmart-ios-sdk", from: "0.0.2")
//        .package(path: "../GitMart")
    ],
    targets: [
        .target(
            name: "ChatKit",
            dependencies: [
                 .product(name: "GitMart", package: "gitmart-ios-sdk")
//                "GitMart"
            ]
        )
    ]
)
