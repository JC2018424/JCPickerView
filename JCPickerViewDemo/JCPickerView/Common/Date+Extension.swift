//
//  Date+Extension.swift
//  QRProject
//
//  Created by 严伟 on 2018/2/23.
//  Copyright © 2018年 yW. All rights reserved.
//

import Foundation
import UIKit

public extension Date {
    
    /// 根据格式返回日期字符串
    ///
    /// - parameter format: 目标格式
    ///
    /// - returns: 日期字符串
    public func stringApplyFormat(_ format: String = "yyyy-MM-dd") -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: self as Date)
    }
    
    /// 根据格式返回日期字符串
    ///
    /// - parameter format: 目标格式
    ///
    /// - returns: 日期字符串
    public func format(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: self as Date)
    }
}

public extension Date {
    
    /// 当前毫秒时间戳
    public static var timeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    /// 字符串转时间类型
    ///
    /// - Returns: 时间类型
    public func stringToDate(_ yearMonth: String) -> Date {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月1日"
        guard let date = dfmatter.date(from: yearMonth) else {
            return Date()
        }
        return date
    }
    
    /// 字符串转时间戳
    ///
    /// - Parameter stringTime: 时间字符串
    /// - Returns: 时间戳
    public func stringToTimeStamp(_ yearMonthDay: String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        guard let date = dfmatter.date(from: yearMonthDay)  else {
            return 0
        }
        let dateStamp: TimeInterval = date.timeIntervalSince1970
        return Int(dateStamp)
        
    }
    
    /// 时间戳转换为年月日
    ///
    /// - Parameter timeStamp: 时间戳
    /// - Returns: 年月日
    public func timeStampToString(_ timeStamp: Int) -> String {
        
        let string = NSString(format: "%d", timeStamp)
        let timeSta: TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        let date = NSDate(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date as Date)
    }
}

public extension Date {
    
    /// 通过年月，获取当年月的天数
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 天数
    public func getCurrentMonthDays(_ year: Int, _ month: Int) -> Int {
        let currentStr = NSString(format: "%d年%d月", year, month)
        let currentDate = Date().stringToDate(currentStr as String)
        return currentDate.dayCount
    }
    
    /// 年份
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// 月份
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    /// 天数
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    /// 小时
    public var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /// 分钟
    public var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    /// 秒
    public var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    /// 星期
    public var chineseWeekday: Int {
        let week = Calendar.current.component(.weekday, from: self)
        return (week == 1) ? 7 : (week - 1)
    }
    
    /// 当月有多少天
    public var dayCount: Int {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0;
    }
}
