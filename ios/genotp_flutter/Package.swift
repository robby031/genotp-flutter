// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "genotp_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "genotp-flutter", targets: ["genotp_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .binaryTarget(
            name: "Genotp",
            path: "Genotp.xcframework"
        ),
        .target(
            name: "genotp_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .target(name: "Genotp")
            ]
        )
    ]
)
