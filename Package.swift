// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "INSPullToRefresh",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "INSPullToRefresh",
            targets: ["INSPullToRefresh"]),
    ],
    targets: [
        .target(
            name: "INSPullToRefresh",
            path: "INSPullToRefresh",
            publicHeadersPath: "include"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
