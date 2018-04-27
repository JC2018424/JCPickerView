//
//  JCCommonColor.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import UIKit

public struct Color {
    /// 常量颜色
    public static let hex_3 = UIColor(hex: "#333333")
    static public let hex_6 = UIColor(hex: "#666666")
    static public let hex_9 = UIColor(hex: "#999999")
    static public let hex_E0E0E0 = UIColor(hex: "#E0E0E0")
    static public let hex_1CA5FA = UIColor(hex: "#1CA5FA")
    static public let hex_00a0ff = UIColor(hex: "#00a0ff")
    static public let hex_f6f6f6 = UIColor(hex: "#f6f6f6")
    static public let hex_eaab47 = UIColor(hex: "#eaab47")
    
    static public let hex_cccccc = UIColor(hex: "#cccccc")
    
    static public let mainColor = hex_1CA5FA
    static public let selectedColor = hex_00a0ff
    
    static public let pagingNormalTextColor = hex_9
    static public let pagingSelectedTextColor = hex_E0E0E0
}

// MARK: - 颜色扩展
public extension UIColor {
    
    public convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    public convenience init(intRed red: Int, green: Int, blue: Int, alpha: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
}
