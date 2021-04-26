// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Sheet",
    platforms: [
       .iOS(.v12),
    ],
    products: [
        .library(name: "Sheet", targets: ["Sheet"]),
    ],
    targets: [
        .target(name: "Sheet"),
    ]
)
