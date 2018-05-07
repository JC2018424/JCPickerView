//
//  UILabel+Extension.swift
//  QRProject
//
//  Created by 严伟 on 2018/2/28.
//  Copyright © 2018年 yW. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel {
    
    /// 设置label的颜色大小
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - font: 字体大小
    public func set(_ color: UIColor = .black,
                    _ font: UIFont = Font.dp(16)) {
        textColor = color
        self.font = font
    }
    
    /// 设置label的颜色大小
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - font: 字体大小
    ///   - alignment: 字体位置
    public func set(_ color: UIColor = .black,
                    _ font: UIFont = Font.dp(16),
                    _ alignment: NSTextAlignment = NSTextAlignment.left) {
        textColor = color
        self.font = font
        textAlignment = alignment
    }
}
