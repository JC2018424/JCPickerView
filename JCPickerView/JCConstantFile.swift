//
//  JCConstantFile.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import UIKit

public struct Constant {
    /// 屏幕大小
    static let screenSize = UIScreen.main.bounds.size
    
    /// 屏幕宽度
    static let screenWidth = UIScreen.main.bounds.width
    
    /// 屏幕高度
    static let screenHeight = UIScreen.main.bounds.height
    
    /// 状态栏的高度
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    /// 判断iphoneX
    static let isPhoneX : Bool = (UIScreen.main.bounds.height == 812.0)
    
    /// ios11 系统之后
    static let isAfterIOS11 : Bool =  (Double(UIDevice.current.systemVersion) ?? 0) >= 11.0
    
    /// 导航栏的高度
    static let navHeight : CGFloat = 44.0 + statusBarHeight
    
    /// 分栏的高度
    static let tabBarHeight : CGFloat = isPhoneX ? 83.0 : 49.0
}
