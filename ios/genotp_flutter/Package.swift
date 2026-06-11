// swift-tools-version: 5.9

import PackageDescription

let genotpMobileVersion = "v1.2.4"
let genotpXCFrameworkChecksum = "8fedb824be1f9a2b92cd306984e538c660e2b8e15d1adb9b5b60b12e5e371e34"

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
            url: "https://github.com/robby031/genotp-mobile/releases/download/\(genotpMobileVersion)/Genotp.xcframework.zip",
            checksum: genotpXCFrameworkChecksum
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
