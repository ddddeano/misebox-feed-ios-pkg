// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxFeediOS",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MiseboxFeediOS",
            targets: ["MiseboxFeediOS"]),
    ],
    dependencies: [
        // Ensure these URLs and versions match the actual accessible locations and versions
        .package(url: "https://github.com/ddddeano/FirebaseiOSMisebox.git", from: "1.1.7"),
        .package(url: "https://github.com/ddddeano/GlobalMiseboxiOS.git", from: "1.0.38")
    ],
    targets: [
        .target(
            name: "MiseboxFeediOS",
            dependencies: [
                // Assuming the package products are named after the package itself
                // Replace "FirebaseiOSMisebox" and "GlobalMiseboxiOS" with the actual product names if they differ
                .product(name: "FirebaseiOSMisebox", package: "FirebaseiOSMisebox"),
                .product(name: "GlobalMiseboxiOS", package: "GlobalMiseboxiOS")
            ]),
        .testTarget(
            name: "MiseboxFeediOSTests",
            dependencies: ["MiseboxFeediOS"]),
    ]
)
