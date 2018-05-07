//
//  JCDateView.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import UIKit

// MARK: - 外部接口
extension JCDateView {
    
}

//
final public class JCDateView: UIView {
    
    // MARK: - 公共成员变量
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupParameter()
        setupUI()
    }
    
    required public init(frame: CGRect, _ dateStyle: JCDateAlertEnum,
                         _ dateModel: JCDateModel) {
        super.init(frame: frame)
        
        self.dateModel = dateModel
        self.dateStyle = dateStyle
        let count = dateStyle.componentsCount
        for _ in 0..<count {
            dateDefaultColorArr.append(false)
        }
        
        setupParameter()
        setupUI()
    }
    
    // MARK: - 界面初始化
    
    /// 初始化参数
    internal func setupParameter() {
        let arr = dateModel.getSectedDateArr(dateStyle)
        for i in 0..<arr.count {
            pickerView.selectRow(arr[i], inComponent: i, animated: true)
        }
    }
    
    /// 初始化UI
    internal func setupUI() {
        addSubview(pickerView)
    }
    
    /// 初始化布局
    public override func layoutSubviews() {
        pickerView.frame = bounds
    }
    
    // MARK: - 内部接口
    
    // MARK: - 私有成员变量
    
    /// 无限轮循
    var maxCount: Int = 10000
    
    /// 默认选中颜色已经渲染
    var didSetDefaultColor: Bool = false
    
    /// 日期显示模型
    var dateModel = JCDateModel(JSON: [:])!
    
    /// 日期样式
    var dateStyle: JCDateAlertEnum = .YMD
    
    /// 日期样式，每项是否默认渲染数据源
    var dateDefaultColorArr: [Bool] = []
    
    /// 日历可见的行数
    let visibleRow: Int = 5
    
    // MARK: - 子控件
    
    /// 日期控件
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    // MARK: - 测试
    
}

// MARK: - UITableView代理
extension JCDateView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// 设置列数
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateStyle.componentsCount
    }
    
    /// 设置每列有多少行
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let type = JCDateItemEnum(rawValue: getFactComponet(component)) else { return 100 }
        return dateModel.getComponetRow(type).count
    }
    
    /// 设置行高
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return bounds.height / CGFloat(visibleRow)
    }
    
    /// 设置默认字体颜色
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        // 为选中的样式，颜色
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = Font.dpBold(14)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.textColor = Color.hex_6
        // 给控件赋值
        guard let type = JCDateItemEnum(rawValue: getFactComponet(component)) else { return UILabel() }
        pickerLabel?.text = type.withUnit(vaule: dateModel.getComponetRow(type)[row])
        // 移除选中框的两条横线
        for view in pickerView.subviews {
            if view.bounds.height < 2 {
                view.removeFromSuperview()
            }
        }
        /// 当每一项都渲染出来后，不再进入该方法
        let bool = dateDefaultColorArr.filter { $0 == false }.isEmpty
        if !bool {
            let arr = dateModel.getSectedDateArr(dateStyle)
            for i in 0..<arr.count {
                if let label = pickerView.view(forRow: arr[i], forComponent: i) as? UILabel {
                    dateDefaultColorArr[i] = true
                    label.textColor = Color.selectedColor
                }
            }
        }
        guard let label = pickerLabel else { return UILabel() }
        return label
    }
    
    /// 更改选中的颜色，输出选中的值
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 根据年月，获取当年月的天数
        guard let type = JCDateItemEnum(rawValue: getFactComponet(component)) else { return }
        switch type {
        case .year:
            dateModel.selectYear = dateModel.yearMutArr()[row]
            reloadDaySourse(2)
            break
        case .momnth:
            dateModel.selectMonth = dateModel.monthMutArr()[row]
            reloadDaySourse(2)
            break
        case .day:
            dateModel.selectDay = row + 1
            break
        case .hour:
            dateModel.selectHour = dateModel.hourMutArr[row]
            break
        case .minute:
            dateModel.selectMinute = dateModel.minuteMutArr[row]
            break
        case .second:
            dateModel.selectSecond = dateModel.secondMutArr[row]
            break
        }
        // 通知发送，选中的日期
        let selectDay = (dateModel.selectDay > dateModel.selectDayCount) ? dateModel.selectDayCount : dateModel.selectDay
        // 值传递
        post(selectDay: selectDay)
        // 更改选中的日期的颜色
        selectColor(row: row, component: component)
    }
    
    /// 获取实际component
    internal func getFactComponet(_ component: Int) -> Int {
        switch dateStyle {
        case .HMS, .HM:
            return component + 3
        default:
            return component
        }
    }
    
    /// 通知值传递
    internal func post(selectDay: Int) {
        var model = dateModel
        model.selectDay = selectDay
        let dateStr = dateStyle.dateFormat(model)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDateChange), object: dateStr)
    }
    
    /// 刷新数据源, 因为天数会 因年份，月份的改变发生变化
    internal func reloadDaySourse(_ componet: Int = 2) {
        if dateStyle == .YMDHM || dateStyle == .YMD {
            pickerView.reloadComponent(componet)
            if  dateModel.selectDay > dateModel.selectDayCount {
                dateModel.selectDay = dateModel.selectDayCount
                pickerView.selectRow(dateModel.selectDayCount - 1, inComponent: componet, animated: true)
                selectColor(row: dateModel.selectDayCount - 1, component: componet)
            } else {
                pickerView.selectRow(dateModel.selectDay - 1, inComponent: componet, animated: true)
                selectColor(row: dateModel.selectDay - 1, component: componet)
            }
        }
    }
    
    /// 改变选中颜色
    internal func selectColor(row: Int, component: Int) {
        guard let label = pickerView.view(forRow: row, forComponent: component) as? UILabel else { return }
        label.textColor = Color.selectedColor
    }
}

/// 日期组成
///
/// - year: 年
/// - momnth: 月
/// - day: 日
/// - hour: 小时
/// - minute: 分
/// - minute: 秒
public enum JCDateItemEnum: Int {
    case year = 0
    case momnth = 1
    case day = 2
    case hour = 3
    case minute = 4
    case second = 5
    
    /// 单位
    fileprivate var dateUnit: String {
        switch self {
        case .year:
            return "年"
        case .momnth:
            return "月"
        case .day:
            return "日"
        case .hour:
            return "时"
        case .minute:
            return "分"
        case .second:
            return "秒"
        }
    }
    
    /// 日期带单位显示
    public func withUnit(vaule: Int) -> String {
        return String(format: "%02d", vaule) + dateUnit
    }
}


