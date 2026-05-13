//
//  VDKit.swift
//  VDText
//
//  Created by Harwyn T'an on 2020/10/21.
//  Migrated from VDText-Swift on 2026/05/13.
//

import Foundation

/// VDText 命名空间包装器。
///
/// 通过 `obj.vd` 访问 VDText 提供的扩展能力，避免直接污染目标类型命名空间，
/// 与 `vd_xxx` 前缀风格相比更接近 Swift 的语法习惯。
///
/// 使用方式：
/// ```swift
/// // 在 VDText 库内为某个类型挂载扩展
/// extension VDKit where Base: NSAttributedString {
///     var font: UIFont? { /* 实现 */ }
/// }
///
/// // 业务侧调用
/// let f = attrString.vd.font
/// ```
public struct VDKit<Base> {
    public let base: Base

    public init(_ base: Base) {
        self.base = base
    }
}

/// 让目标类型支持 `vd` 命名空间扩展点。
///
/// VDText 默认让 `NSObject` 遵循该协议，因此所有继承自 `NSObject` 的
/// Foundation / UIKit 类型都自动获得 `obj.vd` 入口。
public protocol VDKitNamespaceWrappable {
    associatedtype WrapperType
    static var vd: VDKit<WrapperType>.Type { get set }
    var vd: VDKit<WrapperType> { get set }
}

extension VDKitNamespaceWrappable {
    /// 类型层面的扩展入口：`SomeType.vd.xxx`。
    public static var vd: VDKit<Self>.Type {
        get { VDKit<Self>.self }
        // 这里的 setter 只为让 `SomeType.vd.xxx = value` 写法在编译器看来是 lvalue（允许编译通过）。
        // VDKit 是结构体值类型且不持有可变状态，写入本身没有实际意义，因此显式丢弃 newValue。
        set { _ = newValue }
    }

    /// 实例层面的扩展入口：`instance.vd.xxx`。
    public var vd: VDKit<Self> {
        get { VDKit(self) }
        // 同上：允许 `obj.vd.xxx = value` 这类链式写法在语法层面成立。
        // 真正的 mutation 是否生效，取决于 VDKit 上对应属性 setter 内部如何修改 base。
        set { _ = newValue }
    }
}

extension NSObject: VDKitNamespaceWrappable { }
