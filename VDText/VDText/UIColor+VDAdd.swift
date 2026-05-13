//
//  UIColor+VDAdd.swift
//  VDText
//
//  Created by Harwyn T'an on 2017/6/6.
//  Copyright © 2020 vvard3n. All rights reserved.
//

import UIKit

public extension UIColor {

    /// 用十六进制字符串创建颜色，alpha 默认 1.0
    ///
    /// 支持的格式：`@"#123456"`、`@"0X123456"`、`@"123456"`
    /// - Parameter color: 十六进制字符串
    /// - Returns: 颜色对象；格式非法时返回 `clear`
    @objc(vd_colorWithHexString:)
    static func vd_color(hexString color: String) -> UIColor {
        return vd_color(hexString: color, alpha: 1.0)
    }

    /// 用十六进制字符串创建颜色
    /// - Parameters:
    ///   - color: 十六进制字符串
    ///   - alpha: 透明度
    @objc(vd_colorWithHexString:alpha:)
    static func vd_color(hexString color: String, alpha: CGFloat) -> UIColor {
        var cString = color
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        guard cString.count >= 6 else { return .clear }

        if cString.hasPrefix("0X") {
            cString = String(cString.dropFirst(2))
        }
        if cString.hasPrefix("#") {
            cString = String(cString.dropFirst(1))
        }
        guard cString.count == 6 else { return .clear }

        let scanner = Scanner(string: cString)
        var hexValue: UInt64 = 0
        guard scanner.scanHexInt64(&hexValue) else { return .clear }

        let r = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexValue & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
