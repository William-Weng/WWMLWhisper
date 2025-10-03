// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWMLWhisper",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "WWMLWhisper", targets: ["WWMLWhisper"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWNetworking.git", from: "1.8.11")
    ],
    targets: [
        .target(name: "WWMLWhisper", dependencies: ["Whisper", "WWNetworking"]),
        .binaryTarget(name: "Whisper", url: "https://github.com/William-Weng/WWMLWhisper/releases/download/0.0.0/Whisper.xcframework.zip", checksum: "23bed1f72efa0012b843281cba7eec9d97373fc808e3cad0b1d3c1de50d26d67")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
