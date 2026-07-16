// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FinderGitCloneCore",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "FinderGitCloneCore",
            targets: ["FinderGitCloneCore"]
        )
    ],
    targets: [
        .target(
            name: "FinderGitCloneCore",
            dependencies: [],
            path: "Sources/FinderGitCloneCore"
        ),
        .testTarget(
            name: "FinderGitCloneCoreTests",
            dependencies: ["FinderGitCloneCore"],
            path: "Tests/FinderGitCloneCoreTests"
        )
    ]
)
