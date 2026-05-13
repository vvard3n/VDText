//
//  NSAttributedString+VDAdd.swift
//  VDText
//
//  Created by VDText on 2024/03/21.
//  Copyright © 2024 VDText. All rights reserved.
//

import UIKit
import CoreText

/// 获取预定义的属性字符串
/// 包含 UIKit、CoreText 和 VDText 中定义的所有属性
extension NSAttributedString {
    
    /// 将字符串归档为数据
    /// - Returns: 如果发生错误则返回 nil
    func vd_archiveToData() -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        } catch {
            return nil
        }
    }
    
    /// 从数据中解档字符串
    /// - Parameter data: 已归档的属性字符串数据
    /// - Returns: 如果发生错误则返回 nil
    static func vd_unarchiveFromData(_ data: Data) -> NSAttributedString? {
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
        } catch {
            return nil
        }
    }
    
    // MARK: - 获取字符属性信息
    
    /// 返回第一个字符的属性
    @objc var vd_attributes: [NSAttributedString.Key: Any]? {
        return attributes(at: 0, effectiveRange: nil)
    }
    
    /// 返回指定索引处字符的属性
    /// - Parameter index: 要返回属性的字符索引
    /// - Returns: 指定索引处字符的属性
    func vd_attributes(at index: Int) -> [NSAttributedString.Key: Any]? {
        return attributes(at: index, effectiveRange: nil)
    }
    
    /// 返回指定索引处字符的特定属性值
    /// - Parameters:
    ///   - attributeName: 属性名称
    ///   - index: 要返回属性的字符索引
    /// - Returns: 指定属性的值，如果没有该属性则返回 nil
    func vd_attribute(_ attributeName: NSAttributedString.Key, at index: Int) -> Any? {
        return attribute(attributeName, at: index, effectiveRange: nil)
    }
    
    // MARK: - 获取字符属性作为属性
    
    /// 文本的字体（只读）
    /// 默认是 Helvetica (Neue) 12
    @objc var vd_font: UIFont? {
        return attribute(.font, at: 0, effectiveRange: nil) as? UIFont
    }
    
    /// 获取指定索引处的字体
    /// - Parameter index: 字符索引
    /// - Returns: 字体，如果没有则返回 nil
    func vd_font(at index: Int) -> UIFont? {
        return attribute(.font, at: index, effectiveRange: nil) as? UIFont
    }
    
    /// 字间距调整（只读）
    /// 默认是标准字间距
    @objc var vd_kern: NSNumber? {
        return attribute(.kern, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的字间距
    /// - Parameter index: 字符索引
    /// - Returns: 字间距值，如果没有则返回 nil
    func vd_kern(at index: Int) -> NSNumber? {
        return attribute(.kern, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 前景色（只读）
    /// 默认是黑色
    @objc var vd_color: UIColor? {
        return attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
    }
    
    /// 获取指定索引处的前景色
    /// - Parameter index: 字符索引
    /// - Returns: 颜色，如果没有则返回 nil
    func vd_color(at index: Int) -> UIColor? {
        return attribute(.foregroundColor, at: index, effectiveRange: nil) as? UIColor
    }
    
    /// 背景色（只读）
    /// 默认是 nil（无背景）
    @objc var vd_backgroundColor: UIColor? {
        return attribute(.backgroundColor, at: 0, effectiveRange: nil) as? UIColor
    }
    
    /// 获取指定索引处的背景色
    /// - Parameter index: 字符索引
    /// - Returns: 颜色，如果没有则返回 nil
    func vd_backgroundColor(at index: Int) -> UIColor? {
        return attribute(.backgroundColor, at: index, effectiveRange: nil) as? UIColor
    }
    
    /// 描边宽度（只读）
    /// 默认值是 0.0（无描边）
    @objc var vd_strokeWidth: NSNumber? {
        return attribute(.strokeWidth, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的描边宽度
    /// - Parameter index: 字符索引
    /// - Returns: 描边宽度值，如果没有则返回 nil
    func vd_strokeWidth(at index: Int) -> NSNumber? {
        return attribute(.strokeWidth, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 描边颜色（只读）
    /// 默认值是 nil（与前景色相同）
    @objc var vd_strokeColor: UIColor? {
        return attribute(.strokeColor, at: 0, effectiveRange: nil) as? UIColor
    }
    
    /// 获取指定索引处的描边颜色
    /// - Parameter index: 字符索引
    /// - Returns: 颜色，如果没有则返回 nil
    func vd_strokeColor(at index: Int) -> UIColor? {
        return attribute(.strokeColor, at: index, effectiveRange: nil) as? UIColor
    }
    
    /// 文本阴影（只读）
    /// 默认值是 nil（无阴影）
    @objc var vd_shadow: NSShadow? {
        return attribute(.shadow, at: 0, effectiveRange: nil) as? NSShadow
    }
    
    /// 获取指定索引处的阴影
    /// - Parameter index: 字符索引
    /// - Returns: 阴影，如果没有则返回 nil
    func vd_shadow(at index: Int) -> NSShadow? {
        return attribute(.shadow, at: index, effectiveRange: nil) as? NSShadow
    }
    
    /// 删除线样式（只读）
    /// 默认值是 `[]`（无删除线）
    @objc var vd_strikethroughStyle: NSUnderlineStyle {
        return vd_strikethroughStyle(at: 0)
    }
    
    /// 获取指定索引处的删除线样式
    /// - Parameter index: 字符索引
    /// - Returns: 删除线样式；无删除线时返回 `[]`
    func vd_strikethroughStyle(at index: Int) -> NSUnderlineStyle {
        // NSAttributedString 中删除线样式存的是 NSNumber，需要从 rawValue 还原
        guard let number = attribute(.strikethroughStyle, at: index, effectiveRange: nil) as? NSNumber else {
            return []
        }
        return NSUnderlineStyle(rawValue: number.intValue)
    }
    
    /// 删除线颜色（只读）
    /// 默认值是 nil（与前景色相同）
    @objc var vd_strikethroughColor: UIColor? {
        return attribute(.strikethroughColor, at: 0, effectiveRange: nil) as? UIColor
    }
    
    /// 获取指定索引处的删除线颜色
    /// - Parameter index: 字符索引
    /// - Returns: 颜色，如果没有则返回 nil
    func vd_strikethroughColor(at index: Int) -> UIColor? {
        return attribute(.strikethroughColor, at: index, effectiveRange: nil) as? UIColor
    }
    
    /// 下划线样式（只读）
    /// 默认值是 `[]`（无下划线）
    @objc var vd_underlineStyle: NSUnderlineStyle {
        return vd_underlineStyle(at: 0)
    }
    
    /// 获取指定索引处的下划线样式
    /// - Parameter index: 字符索引
    /// - Returns: 下划线样式；无下划线时返回 `[]`
    func vd_underlineStyle(at index: Int) -> NSUnderlineStyle {
        // NSAttributedString 中下划线样式存的是 NSNumber，需要从 rawValue 还原
        guard let number = attribute(.underlineStyle, at: index, effectiveRange: nil) as? NSNumber else {
            return []
        }
        return NSUnderlineStyle(rawValue: number.intValue)
    }
    
    /// 下划线颜色（只读）
    /// 默认值是 nil（与前景色相同）
    @objc var vd_underlineColor: UIColor? {
        return attribute(.underlineColor, at: 0, effectiveRange: nil) as? UIColor
    }
    
    /// 获取指定索引处的下划线颜色
    /// - Parameter index: 字符索引
    /// - Returns: 颜色，如果没有则返回 nil
    func vd_underlineColor(at index: Int) -> UIColor? {
        return attribute(.underlineColor, at: index, effectiveRange: nil) as? UIColor
    }
    
    /// 连字控制（只读）
    /// 默认是整数值 1
    @objc var vd_ligature: NSNumber? {
        return attribute(.ligature, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的连字设置
    /// - Parameter index: 字符索引
    /// - Returns: 连字值，如果没有则返回 nil
    func vd_ligature(at index: Int) -> NSNumber? {
        return attribute(.ligature, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 文本效果（只读）
    /// 默认是 nil（无效果）
    @objc var vd_textEffect: String? {
        return attribute(.textEffect, at: 0, effectiveRange: nil) as? String
    }
    
    /// 获取指定索引处的文本效果
    /// - Parameter index: 字符索引
    /// - Returns: 文本效果，如果没有则返回 nil
    func vd_textEffect(at index: Int) -> String? {
        return attribute(.textEffect, at: index, effectiveRange: nil) as? String
    }
    
    /// 字形倾斜（只读）
    /// 默认是 0（无倾斜）
    @objc var vd_obliqueness: NSNumber? {
        return attribute(.obliqueness, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的字形倾斜
    /// - Parameter index: 字符索引
    /// - Returns: 倾斜值，如果没有则返回 nil
    func vd_obliqueness(at index: Int) -> NSNumber? {
        return attribute(.obliqueness, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 字形扩展因子（只读）
    /// 默认是 0（无扩展）
    @objc var vd_expansion: NSNumber? {
        return attribute(.expansion, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的字形扩展因子
    /// - Parameter index: 字符索引
    /// - Returns: 扩展值，如果没有则返回 nil
    func vd_expansion(at index: Int) -> NSNumber? {
        return attribute(.expansion, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 基线偏移（只读）
    /// 默认是 0
    @objc var vd_baselineOffset: NSNumber? {
        return attribute(.baselineOffset, at: 0, effectiveRange: nil) as? NSNumber
    }
    
    /// 获取指定索引处的基线偏移
    /// - Parameter index: 字符索引
    /// - Returns: 偏移值，如果没有则返回 nil
    func vd_baselineOffset(at index: Int) -> NSNumber? {
        return attribute(.baselineOffset, at: index, effectiveRange: nil) as? NSNumber
    }
    
    /// 字形方向控制（只读）
    /// 默认是 false
    @objc var vd_verticalGlyphForm: Bool {
        return (attribute(.verticalGlyphForm, at: 0, effectiveRange: nil) as? NSNumber)?.boolValue ?? false
    }
    
    /// 获取指定索引处的字形方向
    /// - Parameter index: 字符索引
    /// - Returns: 字形方向
    func vd_verticalGlyphForm(at index: Int) -> Bool {
        return (attribute(.verticalGlyphForm, at: index, effectiveRange: nil) as? NSNumber)?.boolValue ?? false
    }
    
//    /// 指定文本语言（只读）
//    /// 默认是未设置
//    var vd_language: String? {
//        return vd_attribute(.language, at: 0) as? String
//    }
//    
//    /// 获取指定索引处的语言设置
//    /// - Parameter index: 字符索引
//    /// - Returns: 语言标识符，如果没有则返回 nil
//    func vd_language(at index: Int) -> String? {
//        return vd_attribute(.language, at: index) as? String
//    }
    
    /// 指定双向覆盖或嵌入（只读）
    @objc var vd_writingDirection: [NSNumber]? {
        return attribute(.writingDirection, at: 0, effectiveRange: nil) as? [NSNumber]
    }
    
    /// 获取指定索引处的书写方向
    /// - Parameter index: 字符索引
    /// - Returns: 书写方向数组，如果没有则返回 nil
    func vd_writingDirection(at index: Int) -> [NSNumber]? {
        return attribute(.writingDirection, at: index, effectiveRange: nil) as? [NSNumber]
    }
    
    /// 段落样式（只读）
    /// 默认是 nil（使用默认段落样式）
    @objc var vd_paragraphStyle: NSParagraphStyle? {
        return attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
    }
    
    /// 获取指定索引处的段落样式
    /// - Parameter index: 字符索引
    /// - Returns: 段落样式，如果没有则返回 nil
    func vd_paragraphStyle(at index: Int) -> NSParagraphStyle? {
        return attribute(.paragraphStyle, at: index, effectiveRange: nil) as? NSParagraphStyle
    }
    
    // MARK: - 获取段落属性作为属性
    
    /// 文本对齐方式（NSParagraphStyle 的包装）
    /// 默认是 NSTextAlignment.natural
    @objc var vd_alignment: NSTextAlignment {
        return vd_paragraphStyle?.alignment ?? .natural
    }
    
    /// 获取指定索引处的文本对齐方式
    /// - Parameter index: 字符索引
    /// - Returns: 文本对齐方式
    func vd_alignment(at index: Int) -> NSTextAlignment {
        return vd_paragraphStyle(at: index)?.alignment ?? .natural
    }
    
    /// 换行模式（NSParagraphStyle 的包装）
    /// 默认是 NSLineBreakMode.byWordWrapping
    @objc var vd_lineBreakMode: NSLineBreakMode {
        return vd_paragraphStyle?.lineBreakMode ?? .byWordWrapping
    }
    
    /// 获取指定索引处的换行模式
    /// - Parameter index: 字符索引
    /// - Returns: 换行模式
    func vd_lineBreakMode(at index: Int) -> NSLineBreakMode {
        return vd_paragraphStyle(at: index)?.lineBreakMode ?? .byWordWrapping
    }
    
    /// 行间距（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_lineSpacing: CGFloat {
        return vd_paragraphStyle?.lineSpacing ?? 0
    }
    
    /// 获取指定索引处的行间距
    /// - Parameter index: 字符索引
    /// - Returns: 行间距
    func vd_lineSpacing(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.lineSpacing ?? 0
    }
    
    /// 段落间距（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_paragraphSpacing: CGFloat {
        return vd_paragraphStyle?.paragraphSpacing ?? 0
    }
    
    /// 获取指定索引处的段落间距
    /// - Parameter index: 字符索引
    /// - Returns: 段落间距
    func vd_paragraphSpacing(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.paragraphSpacing ?? 0
    }
    
    /// 段落前间距（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_paragraphSpacingBefore: CGFloat {
        return vd_paragraphStyle?.paragraphSpacingBefore ?? 0
    }
    
    /// 获取指定索引处的段落前间距
    /// - Parameter index: 字符索引
    /// - Returns: 段落前间距
    func vd_paragraphSpacingBefore(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.paragraphSpacingBefore ?? 0
    }
    
    /// 首行缩进（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_firstLineHeadIndent: CGFloat {
        return vd_paragraphStyle?.firstLineHeadIndent ?? 0
    }
    
    /// 获取指定索引处的首行缩进
    /// - Parameter index: 字符索引
    /// - Returns: 首行缩进
    func vd_firstLineHeadIndent(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.firstLineHeadIndent ?? 0
    }
    
    /// 除首行外的缩进（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_headIndent: CGFloat {
        return vd_paragraphStyle?.headIndent ?? 0
    }
    
    /// 获取指定索引处的除首行外的缩进
    /// - Parameter index: 字符索引
    /// - Returns: 缩进值
    func vd_headIndent(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.headIndent ?? 0
    }
    
    /// 尾部缩进（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_tailIndent: CGFloat {
        return vd_paragraphStyle?.tailIndent ?? 0
    }
    
    /// 获取指定索引处的尾部缩进
    /// - Parameter index: 字符索引
    /// - Returns: 尾部缩进
    func vd_tailIndent(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.tailIndent ?? 0
    }
    
    /// 最小行高（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_minimumLineHeight: CGFloat {
        return vd_paragraphStyle?.minimumLineHeight ?? 0
    }
    
    /// 获取指定索引处的最小行高
    /// - Parameter index: 字符索引
    /// - Returns: 最小行高
    func vd_minimumLineHeight(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.minimumLineHeight ?? 0
    }
    
    /// 最大行高（NSParagraphStyle 的包装）
    /// 默认是 0（无限制）
    @objc var vd_maximumLineHeight: CGFloat {
        return vd_paragraphStyle?.maximumLineHeight ?? 0
    }
    
    /// 获取指定索引处的最大行高
    /// - Parameter index: 字符索引
    /// - Returns: 最大行高
    func vd_maximumLineHeight(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.maximumLineHeight ?? 0
    }
    
    /// 行高倍数（NSParagraphStyle 的包装）
    /// 默认是 0（无倍数）
    @objc var vd_lineHeightMultiple: CGFloat {
        return vd_paragraphStyle?.lineHeightMultiple ?? 0
    }
    
    /// 获取指定索引处的行高倍数
    /// - Parameter index: 字符索引
    /// - Returns: 行高倍数
    func vd_lineHeightMultiple(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.lineHeightMultiple ?? 0
    }
    
    /// 基础书写方向（NSParagraphStyle 的包装）
    /// 默认是 NSWritingDirection.natural
    @objc var vd_baseWritingDirection: NSWritingDirection {
        return vd_paragraphStyle?.baseWritingDirection ?? .natural
    }
    
    /// 获取指定索引处的基础书写方向
    /// - Parameter index: 字符索引
    /// - Returns: 基础书写方向
    func vd_baseWritingDirection(at index: Int) -> NSWritingDirection {
        return vd_paragraphStyle(at: index)?.baseWritingDirection ?? .natural
    }
    
    /// 连字符阈值（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_hyphenationFactor: Float {
        return vd_paragraphStyle?.hyphenationFactor ?? 0
    }
    
    /// 获取指定索引处的连字符阈值
    /// - Parameter index: 字符索引
    /// - Returns: 连字符阈值
    func vd_hyphenationFactor(at index: Int) -> Float {
        return vd_paragraphStyle(at: index)?.hyphenationFactor ?? 0
    }
    
    /// 默认制表符间隔（NSParagraphStyle 的包装）
    /// 默认是 0
    @objc var vd_defaultTabInterval: CGFloat {
        return vd_paragraphStyle?.defaultTabInterval ?? 0
    }
    
    /// 获取指定索引处的默认制表符间隔
    /// - Parameter index: 字符索引
    /// - Returns: 默认制表符间隔
    func vd_defaultTabInterval(at index: Int) -> CGFloat {
        return vd_paragraphStyle(at: index)?.defaultTabInterval ?? 0
    }
    
    /// 制表符停止点数组（NSParagraphStyle 的包装）
    /// 默认是 12 个制表符停止点，间隔为 28.0
    @objc var vd_tabStops: [NSTextTab]? {
        return vd_paragraphStyle?.tabStops
    }
    
    /// 获取指定索引处的制表符停止点数组
    /// - Parameter index: 字符索引
    /// - Returns: 制表符停止点数组
    func vd_tabStops(at index: Int) -> [NSTextTab]? {
        return vd_paragraphStyle(at: index)?.tabStops
    }
    
    // MARK: - 工具方法
    
    /// 返回整个文本范围
    @objc var vd_rangeOfAll: NSRange {
        return NSRange(location: 0, length: length)
    }
    
//    /// 检查是否在整个文本范围内共享相同的属性
//    var vd_isSharedAttributesInAllRange: Bool {
//        let range = vd_rangeOfAll
//        let attributes = vd_attributes
//        var effectiveRange = NSRange()
//        
//        for i in 0..<length {
//            let currentAttributes = self.attributes(at: i, effectiveRange: &effectiveRange)
//            if let attributes = attributes, currentAttributes != attributes {
//                return false
//            }
//        }
//        return true
//    }
    
//    /// 检查是否可以使用 UIKit 绘制
//    /// 如果返回 false，表示至少有一个属性不被 UIKit 支持（如 CTParagraphStyleRef）
//    /// 如果在 UIKit 中显示此字符串，可能会丢失某些属性，甚至导致应用崩溃
//    var vd_canDrawWithUIKit: Bool {
//        // 检查是否包含任何 CoreText 特有的属性
//        let range = vd_rangeOfAll
//        var effectiveRange = NSRange()
//        
//        for i in 0..<length {
//            let attributes = self.attributes(at: i, effectiveRange: &effectiveRange)
//            for (key, value) in attributes {
//                if key.rawValue.hasPrefix("CT") {
//                    return false
//                }
//            }
//        }
//        return true
//    }
}

// MARK: - NSMutableAttributedString 扩展

extension NSMutableAttributedString {
    
    // MARK: - 设置字符属性
    
    /// 为整个文本字符串设置属性
    /// - Parameter attributes: 要设置的属性字典，或 nil 以移除所有属性
    func vd_setAttributes(_ attributes: [NSAttributedString.Key: Any]?) {
        let range = NSRange(location: 0, length: length)
        setAttributes(attributes, range: range)
    }
    
    /// 为整个文本字符串设置特定属性
    /// - Parameters:
    ///   - name: 属性名称
    ///   - value: 属性值，传递 nil 或 NSNull 以移除该属性
    func vd_setAttribute(_ name: NSAttributedString.Key, value: Any?) {
        let range = NSRange(location: 0, length: length)
        vd_setAttribute(name, value: value, range: range)
    }
    
    /// 为指定范围的字符设置特定属性
    /// - Parameters:
    ///   - name: 属性名称
    ///   - value: 属性值，传递 nil 或 NSNull 以移除该属性
    ///   - range: 要应用属性的字符范围
    func vd_setAttribute(_ name: NSAttributedString.Key, value: Any?, range: NSRange) {
        if let value = value, !(value is NSNull) {
            addAttribute(name, value: value, range: range)
        } else {
            removeAttribute(name, range: range)
        }
    }
    
    /// 移除指定范围内的所有属性
    /// - Parameter range: 字符范围
    func vd_removeAttributes(in range: NSRange) {
        setAttributes(nil, range: range)
    }
    
    // MARK: - 设置字符属性作为属性
    
    /// 设置文本字体
    @objc override var vd_font: UIFont? {
        get {
            return vd_font(at: 0)
        }
        set {
            vd_setAttribute(.font, value: newValue)
        }
    }
    
    /// 设置指定范围的字体
    /// - Parameters:
    ///   - font: 字体
    ///   - range: 范围
    func vd_setFont(_ font: UIFont?, range: NSRange) {
        vd_setAttribute(.font, value: font, range: range)
    }
    
    /// 设置字间距
    @objc override var vd_kern: NSNumber? {
        get {
            return vd_kern(at: 0)
        }
        set {
            vd_setAttribute(.kern, value: newValue)
        }
    }
    
    /// 设置指定范围的字间距
    /// - Parameters:
    ///   - kern: 字间距值
    ///   - range: 范围
    func vd_setKern(_ kern: NSNumber?, range: NSRange) {
        vd_setAttribute(.kern, value: kern, range: range)
    }
    
    /// 设置前景色
    @objc override var vd_color: UIColor? {
        get {
            return vd_color(at: 0)
        }
        set {
            vd_setAttribute(.foregroundColor, value: newValue)
        }
    }
    
    /// 设置指定范围的前景色
    /// - Parameters:
    ///   - color: 颜色
    ///   - range: 范围
    func vd_setColor(_ color: UIColor?, range: NSRange) {
        vd_setAttribute(.foregroundColor, value: color, range: range)
    }
    
    /// 设置背景色
    @objc override var vd_backgroundColor: UIColor? {
        get {
            return vd_backgroundColor(at: 0)
        }
        set {
            vd_setAttribute(.backgroundColor, value: newValue)
        }
    }
    
    /// 设置指定范围的背景色
    /// - Parameters:
    ///   - backgroundColor: 背景色
    ///   - range: 范围
    func vd_setBackgroundColor(_ backgroundColor: UIColor?, range: NSRange) {
        vd_setAttribute(.backgroundColor, value: backgroundColor, range: range)
    }
    
    /// 设置描边宽度
    @objc override var vd_strokeWidth: NSNumber? {
        get {
            return vd_strokeWidth(at: 0)
        }
        set {
            vd_setAttribute(.strokeWidth, value: newValue)
        }
    }
    
    /// 设置指定范围的描边宽度
    /// - Parameters:
    ///   - strokeWidth: 描边宽度
    ///   - range: 范围
    func vd_setStrokeWidth(_ strokeWidth: NSNumber?, range: NSRange) {
        vd_setAttribute(.strokeWidth, value: strokeWidth, range: range)
    }
    
    /// 设置描边颜色
    @objc override var vd_strokeColor: UIColor? {
        get {
            return vd_strokeColor(at: 0)
        }
        set {
            vd_setAttribute(.strokeColor, value: newValue)
        }
    }
    
    /// 设置指定范围的描边颜色
    /// - Parameters:
    ///   - strokeColor: 描边颜色
    ///   - range: 范围
    func vd_setStrokeColor(_ strokeColor: UIColor?, range: NSRange) {
        vd_setAttribute(.strokeColor, value: strokeColor, range: range)
    }
    
    /// 设置阴影
    @objc override var vd_shadow: NSShadow? {
        get {
            return vd_shadow(at: 0)
        }
        set {
            vd_setAttribute(.shadow, value: newValue)
        }
    }
    
    /// 设置指定范围的阴影
    /// - Parameters:
    ///   - shadow: 阴影
    ///   - range: 范围
    func vd_setShadow(_ shadow: NSShadow?, range: NSRange) {
        vd_setAttribute(.shadow, value: shadow, range: range)
    }
    
    /// 设置删除线样式
    @objc override var vd_strikethroughStyle: NSUnderlineStyle {
        get {
            return vd_strikethroughStyle(at: 0)
        }
        set {
            vd_setAttribute(.strikethroughStyle, value: NSNumber(value: newValue.rawValue))
        }
    }
    
    /// 设置指定范围的删除线样式
    /// - Parameters:
    ///   - strikethroughStyle: 删除线样式
    ///   - range: 范围
    func vd_setStrikethroughStyle(_ strikethroughStyle: NSUnderlineStyle, range: NSRange) {
        vd_setAttribute(.strikethroughStyle, value: NSNumber(value: strikethroughStyle.rawValue), range: range)
    }
    
    /// 设置删除线颜色
    @objc override var vd_strikethroughColor: UIColor? {
        get {
            return vd_strikethroughColor(at: 0)
        }
        set {
            vd_setAttribute(.strikethroughColor, value: newValue)
        }
    }
    
    /// 设置指定范围的删除线颜色
    /// - Parameters:
    ///   - strikethroughColor: 删除线颜色
    ///   - range: 范围
    func vd_setStrikethroughColor(_ strikethroughColor: UIColor?, range: NSRange) {
        vd_setAttribute(.strikethroughColor, value: strikethroughColor, range: range)
    }
    
    /// 设置下划线样式
    @objc override var vd_underlineStyle: NSUnderlineStyle {
        get {
            return vd_underlineStyle(at: 0)
        }
        set {
            vd_setAttribute(.underlineStyle, value: NSNumber(value: newValue.rawValue))
        }
    }
    
    /// 设置指定范围的下划线样式
    /// - Parameters:
    ///   - underlineStyle: 下划线样式
    ///   - range: 范围
    func vd_setUnderlineStyle(_ underlineStyle: NSUnderlineStyle, range: NSRange) {
        vd_setAttribute(.underlineStyle, value: NSNumber(value: underlineStyle.rawValue), range: range)
    }
    
    /// 设置下划线颜色
    @objc override var vd_underlineColor: UIColor? {
        get {
            return vd_underlineColor(at: 0)
        }
        set {
            vd_setAttribute(.underlineColor, value: newValue)
        }
    }
    
    /// 设置指定范围的下划线颜色
    /// - Parameters:
    ///   - underlineColor: 下划线颜色
    ///   - range: 范围
    func vd_setUnderlineColor(_ underlineColor: UIColor?, range: NSRange) {
        vd_setAttribute(.underlineColor, value: underlineColor, range: range)
    }
    
    /// 设置连字
    @objc override var vd_ligature: NSNumber? {
        get {
            return vd_ligature(at: 0)
        }
        set {
            vd_setAttribute(.ligature, value: newValue)
        }
    }
    
    /// 设置指定范围的连字
    /// - Parameters:
    ///   - ligature: 连字值
    ///   - range: 范围
    func vd_setLigature(_ ligature: NSNumber?, range: NSRange) {
        vd_setAttribute(.ligature, value: ligature, range: range)
    }
    
    /// 设置文本效果
    @objc override var vd_textEffect: String? {
        get {
            return vd_textEffect(at: 0)
        }
        set {
            vd_setAttribute(.textEffect, value: newValue)
        }
    }
    
    /// 设置指定范围的文本效果
    /// - Parameters:
    ///   - textEffect: 文本效果
    ///   - range: 范围
    func vd_setTextEffect(_ textEffect: String?, range: NSRange) {
        vd_setAttribute(.textEffect, value: textEffect, range: range)
    }
    
    /// 设置字形倾斜
    @objc override var vd_obliqueness: NSNumber? {
        get {
            return vd_obliqueness(at: 0)
        }
        set {
            vd_setAttribute(.obliqueness, value: newValue)
        }
    }
    
    /// 设置指定范围的字形倾斜
    /// - Parameters:
    ///   - obliqueness: 倾斜值
    ///   - range: 范围
    func vd_setObliqueness(_ obliqueness: NSNumber?, range: NSRange) {
        vd_setAttribute(.obliqueness, value: obliqueness, range: range)
    }
    
    /// 设置字形扩展因子
    @objc override var vd_expansion: NSNumber? {
        get {
            return vd_expansion(at: 0)
        }
        set {
            vd_setAttribute(.expansion, value: newValue)
        }
    }
    
    /// 设置指定范围的字形扩展因子
    /// - Parameters:
    ///   - expansion: 扩展值
    ///   - range: 范围
    func vd_setExpansion(_ expansion: NSNumber?, range: NSRange) {
        vd_setAttribute(.expansion, value: expansion, range: range)
    }
    
    /// 设置基线偏移
    @objc override var vd_baselineOffset: NSNumber? {
        get {
            return vd_baselineOffset(at: 0)
        }
        set {
            vd_setAttribute(.baselineOffset, value: newValue)
        }
    }
    
    /// 设置指定范围的基线偏移
    /// - Parameters:
    ///   - baselineOffset: 偏移值
    ///   - range: 范围
    func vd_setBaselineOffset(_ baselineOffset: NSNumber?, range: NSRange) {
        vd_setAttribute(.baselineOffset, value: baselineOffset, range: range)
    }
    
    /// 设置字形方向
    @objc override var vd_verticalGlyphForm: Bool {
        get {
            return vd_verticalGlyphForm(at: 0)
        }
        set {
            vd_setAttribute(.verticalGlyphForm, value: NSNumber(value: newValue))
        }
    }
    
    /// 设置指定范围的字形方向
    /// - Parameters:
    ///   - verticalGlyphForm: 字形方向
    ///   - range: 范围
    func vd_setVerticalGlyphForm(_ verticalGlyphForm: Bool, range: NSRange) {
        vd_setAttribute(.verticalGlyphForm, value: NSNumber(value: verticalGlyphForm), range: range)
    }
    
//    /// 设置语言
//    @objc override var vd_language: String? {
//        get {
//            return vd_language()
//        }
//        set {
//            vd_setAttribute(.language, value: newValue)
//        }
//    }
//    
//    /// 设置指定范围的语言
//    /// - Parameters:
//    ///   - language: 语言标识符
//    ///   - range: 范围
//    func vd_setLanguage(_ language: String?, range: NSRange) {
//        vd_setAttribute(.language, value: language, range: range)
//    }
    
    /// 设置书写方向
    @objc override var vd_writingDirection: [NSNumber]? {
        get {
            return vd_writingDirection(at: 0)
        }
        set {
            vd_setAttribute(.writingDirection, value: newValue)
        }
    }
    
    /// 设置指定范围的书写方向
    /// - Parameters:
    ///   - writingDirection: 书写方向数组
    ///   - range: 范围
    func vd_setWritingDirection(_ writingDirection: [NSNumber]?, range: NSRange) {
        vd_setAttribute(.writingDirection, value: writingDirection, range: range)
    }
    
    /// 设置段落样式
    @objc override var vd_paragraphStyle: NSParagraphStyle? {
        get {
            return attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle
        }
        set {
            vd_setAttribute(.paragraphStyle, value: newValue)
        }
    }
    
    /// 设置指定范围的段落样式
    /// - Parameters:
    ///   - paragraphStyle: 段落样式
    ///   - range: 范围
    func vd_setParagraphStyle(_ paragraphStyle: NSParagraphStyle?, range: NSRange) {
        vd_setAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }
    
    // MARK: - 设置段落属性作为属性
    
    /// 设置文本对齐方式
    @objc override var vd_alignment: NSTextAlignment {
        get {
            return vd_alignment(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.alignment = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的文本对齐方式
    /// - Parameters:
    ///   - alignment: 对齐方式
    ///   - range: 范围
    func vd_setAlignment(_ alignment: NSTextAlignment, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.alignment = alignment
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置换行模式
    @objc override var vd_lineBreakMode: NSLineBreakMode {
        get {
            return vd_lineBreakMode(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.lineBreakMode = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的换行模式
    /// - Parameters:
    ///   - lineBreakMode: 换行模式
    ///   - range: 范围
    func vd_setLineBreakMode(_ lineBreakMode: NSLineBreakMode, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置行间距
    @objc override var vd_lineSpacing: CGFloat {
        get {
            return vd_lineSpacing(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.lineSpacing = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的行间距
    /// - Parameters:
    ///   - lineSpacing: 行间距
    ///   - range: 范围
    func vd_setLineSpacing(_ lineSpacing: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置段落间距
    @objc override var vd_paragraphSpacing: CGFloat {
        get {
            return vd_paragraphSpacing(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.paragraphSpacing = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的段落间距
    /// - Parameters:
    ///   - paragraphSpacing: 段落间距
    ///   - range: 范围
    func vd_setParagraphSpacing(_ paragraphSpacing: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.paragraphSpacing = paragraphSpacing
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置段落前间距
    @objc override var vd_paragraphSpacingBefore: CGFloat {
        get {
            return vd_paragraphSpacingBefore(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.paragraphSpacingBefore = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的段落前间距
    /// - Parameters:
    ///   - paragraphSpacingBefore: 段落前间距
    ///   - range: 范围
    func vd_setParagraphSpacingBefore(_ paragraphSpacingBefore: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.paragraphSpacingBefore = paragraphSpacingBefore
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置首行缩进
    @objc override var vd_firstLineHeadIndent: CGFloat {
        get {
            return vd_firstLineHeadIndent(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.firstLineHeadIndent = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的首行缩进
    /// - Parameters:
    ///   - firstLineHeadIndent: 首行缩进
    ///   - range: 范围
    func vd_setFirstLineHeadIndent(_ firstLineHeadIndent: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.firstLineHeadIndent = firstLineHeadIndent
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置除首行外的缩进
    @objc override var vd_headIndent: CGFloat {
        get {
            return vd_headIndent(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.headIndent = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的除首行外的缩进
    /// - Parameters:
    ///   - headIndent: 缩进值
    ///   - range: 范围
    func vd_setHeadIndent(_ headIndent: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.headIndent = headIndent
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置尾部缩进
    @objc override var vd_tailIndent: CGFloat {
        get {
            return vd_tailIndent(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.tailIndent = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的尾部缩进
    /// - Parameters:
    ///   - tailIndent: 尾部缩进
    ///   - range: 范围
    func vd_setTailIndent(_ tailIndent: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.tailIndent = tailIndent
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置最小行高
    @objc override var vd_minimumLineHeight: CGFloat {
        get {
            return vd_minimumLineHeight(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.minimumLineHeight = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的最小行高
    /// - Parameters:
    ///   - minimumLineHeight: 最小行高
    ///   - range: 范围
    func vd_setMinimumLineHeight(_ minimumLineHeight: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.minimumLineHeight = minimumLineHeight
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置最大行高
    @objc override var vd_maximumLineHeight: CGFloat {
        get {
            return vd_maximumLineHeight(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.maximumLineHeight = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的最大行高
    /// - Parameters:
    ///   - maximumLineHeight: 最大行高
    ///   - range: 范围
    func vd_setMaximumLineHeight(_ maximumLineHeight: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.maximumLineHeight = maximumLineHeight
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置行高倍数
    @objc override var vd_lineHeightMultiple: CGFloat {
        get {
            return vd_lineHeightMultiple(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.lineHeightMultiple = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的行高倍数
    /// - Parameters:
    ///   - lineHeightMultiple: 行高倍数
    ///   - range: 范围
    func vd_setLineHeightMultiple(_ lineHeightMultiple: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.lineHeightMultiple = lineHeightMultiple
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置基础书写方向
    @objc override var vd_baseWritingDirection: NSWritingDirection {
        get {
            return vd_baseWritingDirection(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.baseWritingDirection = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的基础书写方向
    /// - Parameters:
    ///   - baseWritingDirection: 基础书写方向
    ///   - range: 范围
    func vd_setBaseWritingDirection(_ baseWritingDirection: NSWritingDirection, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.baseWritingDirection = baseWritingDirection
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置连字符阈值
    @objc override var vd_hyphenationFactor: Float {
        get {
            return vd_hyphenationFactor(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.hyphenationFactor = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的连字符阈值
    /// - Parameters:
    ///   - hyphenationFactor: 连字符阈值
    ///   - range: 范围
    func vd_setHyphenationFactor(_ hyphenationFactor: Float, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.hyphenationFactor = hyphenationFactor
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置默认制表符间隔
    @objc override var vd_defaultTabInterval: CGFloat {
        get {
            return vd_defaultTabInterval(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.defaultTabInterval = newValue
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的默认制表符间隔
    /// - Parameters:
    ///   - defaultTabInterval: 默认制表符间隔
    ///   - range: 范围
    func vd_setDefaultTabInterval(_ defaultTabInterval: CGFloat, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.defaultTabInterval = defaultTabInterval
        vd_setParagraphStyle(style, range: range)
    }
    
    /// 设置制表符停止点数组
    @objc override var vd_tabStops: [NSTextTab]? {
        get {
            return vd_tabStops(at: 0)
        }
        set {
            let style = vd_paragraphStyle?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.tabStops = newValue ?? []
            vd_paragraphStyle = style
        }
    }
    
    /// 设置指定范围的制表符停止点数组
    /// - Parameters:
    ///   - tabStops: 制表符停止点数组
    ///   - range: 范围
    func vd_setTabStops(_ tabStops: [NSTextTab]?, range: NSRange) {
        let style = vd_paragraphStyle(at: range.location)?.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        style.tabStops = tabStops ?? []
        vd_setParagraphStyle(style, range: range)
    }
    
    // MARK: - 工具方法
    
    /// 在指定位置插入字符串
    /// - Parameters:
    ///   - string: 要插入的字符串
    ///   - location: 插入位置
    func vd_insertString(_ string: String, at location: Int) {
        let attributes = attributes(at: location, effectiveRange: nil)
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        insert(attributedString, at: location)
    }
    
    /// 在末尾添加字符串
    /// - Parameter string: 要添加的字符串
    func vd_appendString(_ string: String) {
        let attributes = attributes(at: length - 1, effectiveRange: nil)
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        append(attributedString)
    }

    // MARK: - VDText 自定义属性 setter

    /// 给指定范围设置 backed string（用于自定义渲染后保留原始可读字符）
    /// - Parameters:
    ///   - textBackedString: 备份字符串对象
    ///   - range: 文本范围
    @objc(vd_setTextBackedString:range:)
    func vd_setTextBackedString(_ textBackedString: VDTextBackedString?, range: NSRange) {
        vd_setAttribute(.vdTextBackedString, value: textBackedString, range: range)
    }

    /// 给指定范围设置 binding 属性（将一段文本作为整体处理）
    /// - Parameters:
    ///   - textBinding: binding 对象
    ///   - range: 文本范围
    @objc(vd_setTextBinding:range:)
    func vd_setTextBinding(_ textBinding: VDTextBinding?, range: NSRange) {
        vd_setAttribute(.vdTextBinding, value: textBinding, range: range)
    }

    /// 给指定范围设置 highlight 属性
    /// - Parameters:
    ///   - textHighlight: 高亮对象
    ///   - range: 文本范围
    @objc(vd_setTextHighlight:range:)
    func vd_setTextHighlight(_ textHighlight: VDTextHighlight?, range: NSRange) {
        vd_setAttribute(.vdTextHighlight, value: textHighlight, range: range)
    }

    /// 为指定范围设置高亮（完整参数版）
    /// - Parameters:
    ///   - range: 文本范围
    ///   - color: 文本前景色，传 nil 跳过
    ///   - backgroundColor: 高亮时使用的背景色
    ///   - userInfo: 自定义信息
    ///   - tapAction: 点击高亮回调
    ///   - longPressAction: 长按高亮回调
    @objc(vd_setTextHighlightRange:color:backgroundColor:userInfo:tapAction:longPressAction:)
    func vd_setTextHighlight(range: NSRange,
                             color: UIColor?,
                             backgroundColor: UIColor?,
                             userInfo: [AnyHashable: Any]?,
                             tapAction: VDTextAction?,
                             longPressAction: VDTextAction?) {
        let highlight = VDTextHighlight.highlight(backgroundColor: backgroundColor)
        highlight.userInfo = userInfo
        highlight.tapAction = tapAction
        highlight.longPressAction = longPressAction
        if let color = color {
            vd_setColor(color, range: range)
        }
        vd_setTextHighlight(highlight, range: range)
    }

    /// 为指定范围设置高亮（带 userInfo 的简化版）
    @objc(vd_setTextHighlightRange:color:backgroundColor:userInfo:)
    func vd_setTextHighlight(range: NSRange,
                             color: UIColor?,
                             backgroundColor: UIColor?,
                             userInfo: [AnyHashable: Any]?) {
        vd_setTextHighlight(range: range,
                            color: color,
                            backgroundColor: backgroundColor,
                            userInfo: userInfo,
                            tapAction: nil,
                            longPressAction: nil)
    }

    /// 为指定范围设置高亮（带 tapAction 的简化版）
    @objc(vd_setTextHighlightRange:color:backgroundColor:tapAction:)
    func vd_setTextHighlight(range: NSRange,
                             color: UIColor?,
                             backgroundColor: UIColor?,
                             tapAction: VDTextAction?) {
        vd_setTextHighlight(range: range,
                            color: color,
                            backgroundColor: backgroundColor,
                            userInfo: nil,
                            tapAction: tapAction,
                            longPressAction: nil)
    }

    /// 按宽度计算富文本绘制需要的最小尺寸
    /// - Parameter width: 最大宽度
    /// - Returns: 整数化后的尺寸（向上取整到整数像素）
    @objc(vd_sizeFittingWithWidth:)
    func vd_sizeFitting(width: CGFloat) -> CGSize {
        let textStorage = NSTextStorage(attributedString: self)
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingRect = CGRect(origin: .zero, size: size)

        let textContainer = NSTextContainer(size: size)
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)

        _ = layoutManager.glyphRange(forBoundingRect: boundingRect, in: textContainer)

        let rect = layoutManager.usedRect(for: textContainer)
        return rect.integral.size
    }
}

// MARK: - NSAttributedString VDText 查询接口

extension NSAttributedString {

    /// 返回指定范围的纯文本。
    /// 如果范围内存在 `vdTextBackedString` 属性，会用 backed string 替换对应区段。
    /// - Parameter range: 文本范围
    /// - Returns: 纯文本字符串。range 非法时返回 nil
    @objc(vd_plainTextForRange:)
    func vd_plainText(for range: NSRange) -> String? {
        guard range.location != NSNotFound, range.length != NSNotFound else { return nil }
        let result = NSMutableString()
        guard range.length > 0 else { return result as String }
        let source = self.string as NSString
        enumerateAttribute(.vdTextBackedString, in: range, options: []) { value, subRange, _ in
            if let backed = value as? VDTextBackedString, let backedString = backed.string {
                result.append(backedString)
            } else {
                result.append(source.substring(with: subRange))
            }
        }
        return result as String
    }
}

// MARK: - 仅 NSMutableAttributedString 的额外工具

extension NSMutableAttributedString {

    /// 在连续 ZWJ（U+200D，emoji 连接符）字符范围内把前景色设为透明色。
    ///
    /// emoji（如 👨‍👩‍👧）通常以"基础字符 + ZWJ + 基础字符"形式组合而成。某些渲染场景下
    /// ZWJ 字符自身会被错误地按"色块"渲染出来；把它们的前景色设成 `.clear` 可以掩盖这个问题。
    ///
    /// 注意：NSAttributedString 的 range 单位是 **UTF-16 code unit**，而 ZWJ (U+200D) 在 BMP 内
    /// 只占 1 个 UTF-16 单元，所以下面这种基于 NSString 的 UTF-16 遍历是正确的方式。
    func vd_setClearColorToJoinedEmoji() {
        let ns = string as NSString
        let zwj: unichar = 0x200D
        let total = ns.length
        var i = 0
        while i < total {
            guard ns.character(at: i) == zwj else {
                i += 1
                continue
            }
            let start = i
            while i < total && ns.character(at: i) == zwj {
                i += 1
            }
            vd_setColor(.clear, range: NSRange(location: start, length: i - start))
        }
    }
}

