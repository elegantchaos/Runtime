// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Runtime",
    products: [
        .library(
            name: "Runtime",
            targets: ["Runtime"]
        ),
    ],
    dependencies: [
      // Use `swift package --allow-writing-to-package-directory generate-workflow` to update the workflow for this package.
      .package(url: "https://github.com/elegantchaos/ActionBuilderPlugin.git", from: "2.1.3")
    ],
    targets: [
        .target(
            name: "Runtime"
        ),
        .testTarget(
            name: "RuntimeTests",
            dependencies: ["Runtime"],
            resources: [
                .copy("Resources/Fixture.bundle")
            ]
        ),
    ]
)
