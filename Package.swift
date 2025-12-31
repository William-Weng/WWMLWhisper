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
        .package(url: "https://github.com/William-Weng/WWNetworking.git", from: "1.9.0")
    ],
    targets: [
        .target(name: "WWMLWhisper", dependencies: ["Whisper", "WWNetworking"]),
        .binaryTarget(name: "Whisper", url: "https://github.com/William-Weng/WWMLWhisper/releases/download/0.0.0/Whisper.xcframework.7z", checksum: "23b348f3e85b52a2c2880635a963ee8c61ae870acb4b5871937190cd6a633840")
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
