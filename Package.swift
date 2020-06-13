// swift-tools-version:5.2
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
        .target(name: "Sheet", dependencies: [], path: "./Sources"),
        //.testTarget(name: "CollectionViewTests", dependencies: ["Sheet"]),
    ]
)
