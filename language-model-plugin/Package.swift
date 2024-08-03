// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LanguagueModelPlugin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "LanguagueModelPlugin",
            targets: ["InferencePlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "InferencePlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/InferencePlugin"),
        .testTarget(
            name: "InferencePluginTests",
            dependencies: ["InferencePlugin"],
            path: "ios/Tests/InferencePluginTests")
    ]
)
