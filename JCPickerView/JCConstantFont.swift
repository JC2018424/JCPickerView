//
//  JCConstantFont.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import UIKit

public struct Font {
    // 字体大小常量
    static let dp10 = dp(10)
    static let dp12 = dp(12)
    static let dp13 = dp(13)
    static let dp14 = dp(14)
    static let dp15 = dp(15)
    static let dp16 = dp(16)
    static let dp17 = dp(17)
    static let dp18 = dp(18)
    static let dp20 = dp(20)
    
    /// 设置字体大小
    ///
    /// - Parameter size: 大小
    /// - Returns: 字体
    static public func dp(_ size: Int) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size))
    }
    
    /// 设置加粗字体大小
    ///
    /// - Parameter size: 大小
    /// - Returns: 加粗字体
    static public func dpBold(_ size: Int) -> UIFont {
        return UIFont.boldSystemFont(ofSize: CGFloat(size))
    }
}
