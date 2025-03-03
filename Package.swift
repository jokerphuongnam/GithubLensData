// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v18),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data",
                "Alamofire",
                "Mocker"
            ]
        ),
    ]
)
