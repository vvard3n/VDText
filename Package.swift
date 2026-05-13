// swift-tools-version: 5.9
//
// SwiftPM manifest for VDText.
//
// 仓库说明：
// - 仓库根的 `VDText.xcodeproj` 同时承载库源码与一个 iOS Demo App target。
// - 库源码位于 `VDText/VDText/`（相对仓库根），本 Package 通过 `path:` 指向该目录，
//   既保留 Demo App 工程不变，又允许外部工程通过 SwiftPM 直接依赖本库。
//

import PackageDescription

let package = Package(
    name: "VDText",
    platforms: [
        // 与 .xcodeproj 中 IPHONEOS_DEPLOYMENT_TARGET 一致；
        // SwiftPM 的最小粒度到 .v13（13.0），不影响实际部署目标 13.1 的 App。
        .iOS(.v13)
    ],
    products: [
        .library(name: "VDText", targets: ["VDText"]),
    ],
    targets: [
        .target(
            name: "VDText",
            // 直接复用 .xcodeproj 中库源码的物理路径，避免源码搬动。
            // Demo App target 用到的桥接头放在 `VDText/VDText-Bridging-Header.h`（App 目录下），
            // 不在本 target 的 path 内，无需 exclude。
            path: "VDText/VDText"
        ),
    ]
)
