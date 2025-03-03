// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "GithubLensNetworks",
    platforms: [
        .iOS(.v18),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "GithubLensNetworks",
            targets: ["GithubLensNetworks"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        .package(url: "https://github.com/WeTransfer/Mocker.git", .upToNextMajor(from: "3.0.0"))
    ],
    targets: [
        .target(
            name: "GithubLensNetworks",
            dependencies: [
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "GithubLensNetworksTests",
            dependencies: [
                "GithubLensNetworks",
                "Alamofire",
                "Mocker"
            ]
        ),
    ]
)
