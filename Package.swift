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
            dependencies: ["INSPullToRefreshSampleControls", "INSAnimatable"],
            path: "INSPullToRefresh",
            publicHeadersPath: "INSPullToRefresh"
        ),
        .target(
            name: "INSPullToRefreshSampleControls",
            path: "INSPullToRefreshSampleControls/Default",
            publicHeadersPath: "INSPullToRefreshSampleControls/Default"
        ),
        .target(
            name: "INSAnimatable",
            path: "INSPullToRefreshSampleControls/Animatable",
            publicHeadersPath: "INSPullToRefreshSampleControls/Animatable"
        )
    ],
    swiftLanguageVersions: [.v5]
)
