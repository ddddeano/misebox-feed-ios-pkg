// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MiseboxFeediOS",
    products: [
        .library(
            name: "MiseboxFeediOS",
            targets: ["MiseboxFeediOS"]),
    ],
    dependencies: [
        // Add dependencies here
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "X.X.X"))
    ],
    targets: [
        .target(
            name: "MiseboxFeediOS",
            dependencies: [
                // Add Firebase products you want to use here
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]),
        .testTarget(
            name: "MiseboxFeediOSTests",
            dependencies: ["MiseboxFeediOS"]),
    ]
)
