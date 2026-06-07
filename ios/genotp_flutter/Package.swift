// swift-tools-version: 5.9

import PackageDescription

let genotpMobileVersion = "v1.2.3"
let genotpXCFrameworkChecksum = "80ca03242fee424526519b238efc6ab2f03eca1c3e475c1145e9afff1b210f65"

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
