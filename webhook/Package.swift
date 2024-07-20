// swift-tools-version:5.10
import Foundation
import PackageDescription

let package = Package(
    name: "webhook",
    platforms: [
       .macOS(.v14)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.0.0-beta"),
        .package(url: "https://github.com/Zollerboy1/SwiftCommand.git", from: "1.4.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "SwiftCommand", package: "SwiftCommand"),
            ],
            swiftSettings: swiftSettings,
            plugins: swiftLintPlugins
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings,
            plugins: swiftLintPlugins
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
] }

var swiftLintPlugins: [Target.PluginUsage] {
    Environment.ci ? [] : [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
    ]
}

enum Environment {
    static func find(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
    static var ci: Bool {
        find("CI") != nil
    }
}
