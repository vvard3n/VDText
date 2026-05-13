# VDText

一个面向 iOS 的轻量富文本编辑组件。提供：

- 一个带 `placeholder` 的 `UITextView` 容器视图 `VDTextEditor`；
- 文本"绑定"能力（`VDTextBinding`），让一段字符在选择、删除时被当作一个整体处理（典型场景：`@提及` 高亮链接、表情串、邮箱卡片等）；
- 文本"高亮"能力（`VDTextHighlight`），支持高亮态属性切换 + 点击 / 长按回调；
- 文本"备份串"能力（`VDTextBackedString`），让被自定义渲染替换过的字符（如 emoji）在复制 / 导出时能拿回原始文本；
- 一组 `NSAttributedString` / `NSMutableAttributedString` 便利扩展（`vd_font`、`vd_color`、`vd_setTextBinding(...)` 等）。

> 本仓库源自一个早期的 Objective-C 实现（以及一个废弃的 Swift 雏形 `VDText-Swift`）。**当前主分支已完成完整的 Objective-C → Swift 迁移**，同时保留了 `@objc` 接口，方便存量 OC 代码继续使用。

## 系统要求

- iOS 13.1+
- Xcode 15+（项目设置使用 `SWIFT_VERSION = 6.0`）

## 集成

### Swift Package Manager（推荐）

**Xcode：** `File → Add Package Dependencies…`，地址填仓库 URL（例如 `https://github.com/<your-account>/VDText.git`），选择 `Up to Next Major` 之类的版本规则，将 `VDText` 产品加到目标即可。

**`Package.swift` 中作为依赖：**

```swift
dependencies: [
    .package(url: "https://github.com/<your-account>/VDText.git", from: "1.0.0"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "VDText", package: "VDText"),
        ]
    ),
],
```

> 仓库根的 `Package.swift` 直接复用 `VDText/VDText/` 目录下的源码作为 SwiftPM target，不会带入 Demo App 的代码。最低部署目标 iOS 13.0。

### 手动集成

如果不想引入包管理：

1. 将 `VDText/VDText/` 目录下的所有 `.swift` 文件拖入你的目标；
2. `Build Settings` 中确认 Swift 版本可用（库代码使用了 Swift 5.9+ 引入的 `MainActor.assumeIsolated` 等 API）。

### 运行 Demo

打开 `VDText.xcodeproj` 选 `VDText` scheme 即可运行。该 target 同时承载 Demo App 与历史 OC 兼容（通过 `VDText-Bridging-Header.h` 作为占位），与 SwiftPM 包共用一份源码。

## 快速开始

下面这段示例完整覆盖了 placeholder、binding、highlight、backed-string 四种典型用法。代码摘自工程内 Demo（`VDText/ViewController.swift`）：

```swift
import UIKit

final class DemoController: UIViewController {

    private let editor = VDTextEditor(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        editor.placeholderFont = .systemFont(ofSize: 18)
        editor.placeholderTextColor = UIColor(white: 0, alpha: 0.5)
        editor.placeholderText = "占位文本"
        editor.font = .systemFont(ofSize: 18)
        editor.textColor = .black
        editor.backgroundColor = .systemGroupedBackground
        editor.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)

        view.addSubview(editor)
        editor.frame = CGRect(x: 17, y: 100,
                              width: view.bounds.width - 34,
                              height: 200)
    }

    /// 在当前光标处插入一段"高亮链接"片段：
    /// - 整段套上 VDTextBinding，删除 / 选择时作为一个整体处理；
    /// - 中间可读部分套上 VDTextHighlight，可承接 tap / longPress 回调；
    /// - 整段挂上 VDTextBackedString，复制 / 导出时仍能拿到 "高亮链接" 原文。
    func insertHighlightLink() {
        let textColor = UIColor.black
        let font = UIFont.systemFont(ofSize: 18)
        let highlightColor = UIColor.blue

        let chunk = NSMutableAttributedString(string: " ")
        chunk.vd_color = textColor
        chunk.vd_font = font

        let visible = NSMutableAttributedString(string: "高亮链接")
        visible.vd_color = highlightColor
        visible.vd_font = font
        chunk.append(visible)

        let trailing = NSMutableAttributedString(string: " ")
        trailing.vd_color = textColor
        trailing.vd_font = font
        chunk.append(trailing)

        chunk.vd_setTextBinding(VDTextBinding.binding(deleteConfirm: true),
                                range: NSRange(location: 0, length: chunk.length))
        chunk.vd_setTextHighlight(range: NSRange(location: 1, length: chunk.length - 2),
                                  color: highlightColor,
                                  backgroundColor: nil,
                                  userInfo: ["type": "url", "text": "anyText"])
        chunk.vd_setTextBackedString(VDTextBackedString.string(with: "高亮链接"),
                                     range: NSRange(location: 0, length: chunk.length))

        let mutable = NSMutableAttributedString(attributedString: editor.attributedText ?? .init())
        let cursor = editor.selectedRange
        mutable.insert(chunk, at: cursor.location)
        editor.attributedText = mutable
        editor.selectedRange = NSRange(location: cursor.location + chunk.length, length: 0)
    }
}
```

## 核心类型

| 类型 | 作用 |
| --- | --- |
| `VDTextEditor` | 富文本编辑容器视图，内嵌 `VDTextView`，负责 placeholder 渲染、KVO 跟随、delegate 转发。 |
| `VDTextView` | `UITextView` 子类，重写 `deleteBackward` 以配合 `VDTextBinding` 做"整段删除 / 二次确认删除"。 |
| `VDTextBinding` | `vdTextBinding` 属性对应的值类型，描述被绑定字符串的删除行为。 |
| `VDTextHighlight` | `vdTextHighlight` 属性对应的值类型，描述高亮态属性、`userInfo`、`tapAction`、`longPressAction`。 |
| `VDTextBackedString` | `vdTextBackedString` 属性对应的值类型，承载原始可读文本以便复制 / 导出。 |
| `NSAttributedString.Key.vd*` | 三个属性 Key：`.vdTextBinding` / `.vdTextHighlight` / `.vdTextBackedString`，同时通过 `VDTextAttributeNames` 暴露给 OC 端。 |

## API 风格说明

工程内同时存在两套扩展入口：

1. **`vd_` 前缀风格**（默认）：例如 `attr.vd_font`、`mutable.vd_setTextBinding(...)`，全部带 `@objc`，与历史 OC 工程的 API 一一对应。是目前推荐使用的入口。
2. **`obj.vd.xxx` 命名空间风格**（预留）：通过 `VDKit<Base>` + `VDKitNamespaceWrappable` 提供（参见 `VDKit.swift`），类似 RxSwift 的 `.rx` / SnapKit 的 `.snp`。目前 **仅提供入口骨架，尚未挂载具体扩展**；未来新增 Swift-only API 时建议走这套入口，旧入口保留作为 OC 兼容。

两套风格**可以共存**，业务侧按需选择即可。

## 目录结构

```
VDText/
├── VDText.xcodeproj
└── VDText/                              ← 应用 target
    ├── AppDelegate.swift
    ├── SceneDelegate.swift
    ├── ViewController.swift             ← Demo 入口
    ├── Assets.xcassets
    ├── Base.lproj/
    ├── Info.plist
    └── VDText/                          ← 库源码
        ├── VDKit.swift                  ← .vd 命名空间入口
        ├── VDTextAttribute.swift        ← 三个 VDText 属性的模型
        ├── NSAttributedString+VDAdd.swift
        ├── UIColor+VDAdd.swift
        ├── VDTextView.swift             ← UITextView 子类
        ├── VDTextEditor.swift           ← 带 placeholder 的容器视图
        └── VDText-Bridging-Header.h
```

## 历史

- **2019 – 2020**：以 Objective-C 实现 `VDTextEditor` / `VDTextView` / 属性模型 / NSAttributedString 扩展。
- **2020 ~**：在独立仓库 `VDText-Swift` 中尝试 Swift 化，但仅完成最小子集（绑定、命名空间），未推进。
- **2026-05**：本仓库完成完整的 OC → Swift 迁移；保留 `@objc` 接口与原 OC API 命名一致；引入 `VDKit` 命名空间作为后续 Swift 风格 API 的演进入口；清理 `VDTextKVO` / `UITextView+VDAdd` 等无用代码。

## License

MIT License. 见 `LICENSE`。
