//
//  JCDateViewManager.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

/// 日期显示视图管理对象
final public class JCDateViewManager {
    
    /// 日期当前显示 View
    static func show(_ dateStyle: JCDateAlertEnum = .YMD) -> UIView {
        /// 日期显示模型
        guard let dateModel = JCDateModel(JSON: [:]) else { return UIView() }
        let view = JCDateView(frame: CGRect.zero, dateStyle, dateModel)
        return view
    }
}

///
public struct JCDateModel: Mappable {
    
    // MARK: - 公共成员变量
    
    /// 当前选中的年
    public var selectYear: Int = Date().year {
        didSet {
            selectDayCount = Date().getCurrentMonthDays(selectYear, selectMonth)
        }
    }
    
    /// 当前选中的月
    public var selectMonth: Int = Date().month {
        didSet {
            selectDayCount = Date().getCurrentMonthDays(selectYear, selectMonth)
        }
    }
    
    /// 当前选中的日
    public var selectDay: Int = Date().day
    
    /// 当前选中的小时
    public var selectHour: Int = Date().hour
    
    /// 当前选中的分
    public var selectMinute: Int = Date().minute
    
    /// 当前选中的秒
    public var selectSecond: Int = Date().second
    
    /// 年range
    public var yearRange: Int = 30
    
    /// 当前选中的年月时，天数
    public var selectDayCount: Int = 0 {
        didSet {
            var arr = [Int]()
            for i in 1...selectDayCount {
                arr.append(i)
            }
            dayMutArr = arr
        }
    }
    
    /// 日数组根据当前年份，月份，计算有多少天
    public var dayMutArr = [Int]()
    
    /// 小时
    public var hourMutArr: [Int] {
        var arr = [Int]()
        for i in 0...23 {
            arr.append(i)
        }
        return arr
    }
    
    /// 分
    public var minuteMutArr: [Int] {
        var arr = [Int]()
        for i in 0...59 {
            arr.append(i)
        }
        return arr
    }
    
    /// 秒
    public var secondMutArr: [Int] {
        var arr = [Int]()
        for i in 0...59 {
            arr.append(i)
        }
        return arr
    }
    
    public mutating func mapping(map: Map) {
        selectYear <- map["selectYear"]
        selectMonth <- map["selectMonth"]
        selectDay <- map["selectDay"]
        selectHour <- map["selectHour"]
        selectMinute <- map["selectMinute"]
        selectSecond <- map["selectSecond"]
    }
    
    public init?(map: Map) { }
    
    // MARK: - 内部接口
    
    /// 获取年份数组
    public func yearMutArr(yearRange: Int = 30) -> [Int] {
        var arr = [Int]()
        for i in (Date().year - yearRange)..<(Date().year + yearRange) {
            arr.append(i)
        }
        return arr
    }
    
    /// 获取月份数组
    public func monthMutArr() -> [Int]  {
        var arr = [Int]()
        for i in 1...12 {
            arr.append(i)
        }
        return arr
    }
    
    // MARK: - 私有成员变量
    
    /// 选中日期组成的数组
    public func getSectedDateArr(_ dateStyle: JCDateAlertEnum) -> [Int] {
        switch dateStyle {
        case .YMDHM:
            return [yearRange, selectMonth - 1, selectDay - 1,
                    selectHour, selectMinute]
        case .YMD:
            return [yearRange, selectMonth - 1, selectDay - 1]
        case .YM:
            return [yearRange, selectMonth - 1]
        case .HMS:
            return [selectHour, selectMinute, selectSecond]
        case .HM:
            return [selectMinute, selectSecond]
        }
    }
    
    /// 获取日期每项显示的数组
    public func getComponetRow(_ type: JCDateItemEnum) -> [Int] {
        switch type {
        case .year:
            return yearMutArr()
        case .momnth:
            return monthMutArr()
        case .day:
            return dayMutArr
        case .hour:
            return hourMutArr
        case .minute:
            return minuteMutArr
        case .second:
            return secondMutArr
        }
    }
}
