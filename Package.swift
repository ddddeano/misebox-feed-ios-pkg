// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxiOSFeed",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxiOSFeed",
            targets: ["MiseboxiOSFeed"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.1.7"),
        .package(url: "https://github.com/ddddeano/misebox-ios-global-pkg.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "MiseboxiOSFeed",
            dependencies: [
                .product(name: "FirebaseiOSMisebox", package: "FirebaseiOSMisebox"),
                .product(name: "MiseboxiOSGlobal", package: "misebox-ios-global-pkg")
            ]),
        .testTarget(
            name: "MiseboxiOSFeedTests",
            dependencies: ["MiseboxiOSFeed"]),
    ]
)
