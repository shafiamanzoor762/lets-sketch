// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "AppPackages",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Canvas", targets: ["Canvas"]),
        .library(name: "CustomViews", targets: ["CustomViews"]),
        .library(name: "Data", targets: ["Data"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "GalleryFeature", targets: ["GalleryFeature"]),
        .library(name: "Router", targets: ["Router"])
    ],
    targets: [
        .target(name: "Canvas", dependencies: ["Data", "Domain", "Router", "CustomViews"]),
        .target(name: "CustomViews"),
        .target(name: "Data"),
        .target(name: "Domain"),
        .target(name: "GalleryFeature", dependencies: ["Data", "Domain", "CustomViews", "Router"]),
        .target(name: "Router")
    ]
)
