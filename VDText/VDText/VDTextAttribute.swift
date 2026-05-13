//
//  VDTextAttribute.swift
//  VDText
//
//  Created by Harwyn T'an on 2019/12/12.
//  Copyright © 2020 vvard3n. All rights reserved.
//

import UIKit

// MARK: - Attribute Name 常量

public extension NSAttributedString.Key {
    /// 用于将多个字符"绑定"为一个整体的属性 Key（VDTextView 在选择/删除时会把绑定范围当成单字符处理）
    static let vdTextBinding = NSAttributedString.Key("VDTextBinding")
    /// 高亮属性 Key
    static let vdTextHighlight = NSAttributedString.Key("VDTextHighlight")
    /// 文本"备份字符串"属性 Key（用于在富文本被自定义渲染后，复制/导出时拿到原始可读字符串）
    static let vdTextBackedString = NSAttributedString.Key("VDTextBackedString")
}

// MARK: - 与 OC 兼容的字符串常量

/// 与原 OC 工程中 `VDTextBindingAttributeName` 兼容的常量。
public let VDTextBindingAttributeName: String = NSAttributedString.Key.vdTextBinding.rawValue

/// 与原 OC 工程中 `VDTextHighlightAttributeName` 兼容的常量。
public let VDTextHighlightAttributeName: String = NSAttributedString.Key.vdTextHighlight.rawValue

/// 与原 OC 工程中 `VDTextBackedStringAttributeName` 兼容的常量。
public let VDTextBackedStringAttributeName: String = NSAttributedString.Key.vdTextBackedString.rawValue

/// 给 OC 端使用的常量包装：`[VDTextAttributeNames bindingName]` 之类。
/// （Swift 不支持把全局 `let` 暴露给 OC，所以用 class static 包装。）
@objcMembers
public final class VDTextAttributeNames: NSObject {
    /// 等同于 OC 中的 `VDTextBindingAttributeName`
    public static let bindingName = VDTextBindingAttributeName
    /// 等同于 OC 中的 `VDTextHighlightAttributeName`
    public static let highlightName = VDTextHighlightAttributeName
    /// 等同于 OC 中的 `VDTextBackedStringAttributeName`
    public static let backedStringName = VDTextBackedStringAttributeName

    private override init() { super.init() }
}

// MARK: - 闭包类型

/// 点击/长按高亮时的回调闭包类型
public typealias VDTextAction = (_ containerView: UIView, _ text: NSAttributedString, _ range: NSRange, _ rect: CGRect) -> Void

// MARK: - VDTextBackedString

/// `VDTextBackedString` 用作富文本 `vdTextBackedString` 属性的值。
///
/// 用途：当一段富文本用自定义字符替换了原始可读内容（例如把 ":)" 替换成 😊 emoji），
/// 可以把原始字符串保存在 backed string 中，供拷贝/导出时使用。
@objcMembers
public final class VDTextBackedString: NSObject, NSCoding, NSCopying {

    /// 备份字符串
    public var string: String?

    public override init() {
        super.init()
    }

    /// 便捷构造
    /// - Parameter string: 备份字符串
    public static func string(with string: String?) -> VDTextBackedString {
        let one = VDTextBackedString()
        one.string = string
        return one
    }

    // MARK: NSCoding

    public func encode(with coder: NSCoder) {
        coder.encode(string, forKey: "string")
    }

    public required init?(coder: NSCoder) {
        super.init()
        self.string = coder.decodeObject(of: NSString.self, forKey: "string") as String?
    }

    // MARK: NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let one = VDTextBackedString()
        one.string = string
        return one
    }
}

// MARK: - VDTextBinding

/// `VDTextBinding` 用作富文本 `vdTextBinding` 属性的值。
///
/// 给一段文本加上 binding 属性后，`VDTextView` 在选择/删除时会把这段文本作为一个整体处理。
@objcMembers
public final class VDTextBinding: NSObject, NSCoding, NSCopying {

    /// 删除时是否需要二次确认（先选中再删除）
    public var deleteConfirm: Bool = false

    public override init() {
        super.init()
    }

    /// 便捷构造
    /// - Parameter deleteConfirm: 删除时是否需要二次确认
    public static func binding(deleteConfirm: Bool) -> VDTextBinding {
        let one = VDTextBinding()
        one.deleteConfirm = deleteConfirm
        return one
    }

    // MARK: NSCoding

    public func encode(with coder: NSCoder) {
        coder.encode(NSNumber(value: deleteConfirm), forKey: "deleteConfirm")
    }

    public required init?(coder: NSCoder) {
        super.init()
        let number = coder.decodeObject(of: NSNumber.self, forKey: "deleteConfirm")
        self.deleteConfirm = number?.boolValue ?? false
    }

    // MARK: NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let one = VDTextBinding()
        one.deleteConfirm = deleteConfirm
        return one
    }
}

// MARK: - VDTextHighlight

/// `VDTextHighlight` 用作富文本 `vdTextHighlight` 属性的值。
///
/// 描述了"高亮态"下要替换/移除的属性集合，以及高亮的点击/长按行为。
@objcMembers
public final class VDTextHighlight: NSObject, NSCoding, NSCopying {

    /// 高亮时需要应用的属性字典。
    /// Key 与 CoreText/UIKit 属性一致；Value 若为 `NSNull`，表示在高亮时移除该属性。
    public var attributes: [String: Any]?

    /// 自定义信息字典
    public var userInfo: [AnyHashable: Any]?

    /// 点击高亮时的回调；为 nil 时由所在 view 的 delegate 处理
    public var tapAction: VDTextAction?

    /// 长按高亮时的回调；为 nil 时由所在 view 的 delegate 处理
    public var longPressAction: VDTextAction?

    public override init() {
        super.init()
    }

    /// 用指定的属性字典创建高亮对象
    /// - Parameter attributes: 高亮时应用的属性。Value 若为 `NSNull` 则表示移除该属性。
    public static func highlight(attributes: [String: Any]?) -> VDTextHighlight {
        let one = VDTextHighlight()
        one.attributes = attributes
        return one
    }

    /// 用指定背景色创建高亮对象（占位实现，与原 OC 行为一致）
    /// - Parameter color: 背景色
    public static func highlight(backgroundColor color: UIColor?) -> VDTextHighlight {
        _ = color // 历史 OC 实现中尚未把 backgroundColor 应用到 attributes，这里保持等价行为
        return VDTextHighlight()
    }

    // MARK: 设置常用属性

    /// 在高亮态下应用指定字体
    public func setFont(_ font: UIFont?) {
        setTextAttribute(NSAttributedString.Key.font.rawValue, value: font)
    }

    /// 在高亮态下应用指定前景色
    public func setColor(_ color: UIColor?) {
        setTextAttribute(NSAttributedString.Key.foregroundColor.rawValue, value: color)
    }

    /// 在 `attributes` 字典中设置一项属性
    /// - Parameters:
    ///   - attribute: 属性名（CoreText / UIKit 的 attribute name）
    ///   - value: 属性值，传 `nil` 等价于 `NSNull`，表示在高亮时移除该属性
    public func setTextAttribute(_ attribute: String, value: Any?) {
        var dict = attributes ?? [:]
        dict[attribute] = value ?? NSNull()
        attributes = dict
    }

    // MARK: NSCopying

    public func copy(with zone: NSZone? = nil) -> Any {
        let one = VDTextHighlight()
        one.attributes = attributes
        one.userInfo = userInfo
        one.tapAction = tapAction
        one.longPressAction = longPressAction
        return one
    }

    // MARK: NSCoding（占位实现，与原 OC 注释掉的版本一致——闭包不可归档）

    public func encode(with coder: NSCoder) {
        // 闭包无法归档；只归档可序列化部分
        if let attributes = attributes,
           let data = try? NSKeyedArchiver.archivedData(withRootObject: attributes, requiringSecureCoding: false) {
            coder.encode(data, forKey: "attributes")
        }
    }

    public required init?(coder: NSCoder) {
        super.init()
        if let data = coder.decodeObject(of: NSData.self, forKey: "attributes") as Data? {
            // 高亮 attributes 可能包含闭包/UIColor 等异构对象，按 OC 历史行为保持宽松解档：
            let classes: [AnyClass] = [
                NSDictionary.self,
                NSString.self,
                NSNumber.self,
                NSArray.self,
                NSNull.self,
                UIColor.self,
                UIFont.self
            ]
            let unarchived = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: classes, from: data)
            self.attributes = unarchived as? [String: Any]
        }
    }
}
