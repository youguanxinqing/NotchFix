// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NotchFix",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "NotchFix", targets: ["NotchFix"])
    ],
    targets: [
        .executableTarget(
            name: "NotchFix",
            path: "Sources",
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-sectcreate", "-Xlinker", "__TEXT", "-Xlinker", "__info_plist", "-Xlinker", "NotchFix.entitlements"])
            ]
        )
    ]
)
