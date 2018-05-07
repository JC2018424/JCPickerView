//
//  JCPickerView.swift
//  JCPickerView
//
//  Created by JC on 2018/3/15.
//  Copyright © 2018年 JC. All rights reserved.
//

import UIKit
import Then
import SnapKit

// 日期改变通知
public let kDateChange = "kDateChange"

/// 选择的时间回调
public typealias JCDateStrBlock = (_ date: String) -> Void

/// 取消回调
public typealias JCVoidBlock = () -> Void

public extension Selector {
    /// 确认
    static let confirm = #selector(JCPickerView.confirmAction)
    /// 取消
    static let cancel = #selector(JCPickerView.cancelAction)
    /// 日期改变
    static let dateChange = #selector(JCPickerView.dateChange)
}

/// 日期弹框显示的类型
///
/// - YMDHMS: 年月日时分
/// - YMD: 年月日
/// - YM:  年月
/// - HMS: 时分秒
/// - HM:  时分
public enum JCDateAlertEnum: Int {
    case YMDHM = 0
    case YMD = 1
    case YM = 2
    case HMS = 3
    case HM = 4
    
    /// 时间描述
    public var titleDesc: String {
        switch self {
        case .YMDHM, .YMD, .YM:
            return "选择日期"
        case .HMS, .HM:
            return "选择时间"
        }
    }
    
    /// 显示时间格式
    public func dateFormat(_ model: JCDateModel) -> String {
        switch self {
        case .YMDHM:
            return NSString(format: "%d年%02d月%02d日 %02d时%02d分", model.selectYear, model.selectMonth, model.selectDay, model.selectHour, model.selectMinute) as String
        case .YMD:
            return String(format: "%d年%02d月%02d日", model.selectYear, model.selectMonth, model.selectDay)
        case .YM:
            return String(format: "%d年%02d月", model.selectYear, model.selectMonth, model.selectDay)
        case .HMS:
            return String(format: "%02d时%02d分%02d秒", model.selectHour, model.selectMinute, model.selectSecond)
        case .HM:
            return String(format: "%02d时%02d分", model.selectHour, model.selectMinute)
        }
    }
    
    /// 日期显示列数
    public var componentsCount: Int {
        switch self {
        case .YMDHM:
            return 5
        case .YMD, .HMS:
            return 3
        case .YM, .HM:
            return 2
        }
    }
    
    /// 具体选择的时间是否显示
    public var hiddenVerticalLine: Bool {
        switch self {
        case .YMDHM, .YMD, .HMS:
            return false
        case .YM, .HM:
            return true
        }
    }
    
    /// 默认时间显示
    public var defaultDate: String {
        let year = Date().year
        let month = Date().month
        let day = Date().day
        let hour = Date().hour
        let minute = Date().minute
        let second = Date().second
        switch self {
        case .YMDHM:
            let date = String(format: "%d年%02d月%02d %02d时%02d分", year, month, day, hour, minute)
            return date
        case .YMD:
            let date = String(format: "%d年%02d月%02d日", year, month, day)
            return date
        case  .YM:
            let date = String(format: "%d年%02d日", year, month)
            return date
        case .HMS:
            let date = String(format: "%02d时%02d分%02d秒", hour, minute, second)
            return date
        case .HM:
            let date = String(format: "%02d时%02d分", hour, minute)
            return date
        }
    }
}

// MARK: - 外部接口
extension JCPickerView {
    
    /// 显示弹框
    ///
    /// - Parameters:
    ///   - cancelBlock: 取消回调
    ///   - confirmBlock: 确认回调
    static func show(cancelBlock: JCVoidBlock? = nil,
                     confirmBlock: JCDateStrBlock? = nil,
                     dateStyle: JCDateAlertEnum = .YMD) {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let calendar = JCPickerView(frame: CGRect.zero, dateStyle: dateStyle)
        calendar.cancelBlock = cancelBlock
        calendar.confirmBlock = confirmBlock
        /// 添加控件
        keyWindow.addSubview(calendar)
        keyWindow.bringSubview(toFront: calendar)
        // 设置比例
        calendar.alertView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        calendar.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        // 日期控件显示
        UIView.animate(withDuration: 0.25, animations: {
            calendar.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
            calendar.alertView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
}

///
final public class JCPickerView: UIView {
    
    // MARK: - 公共成员变量
    
    /// 确认回调
    public var confirmBlock: JCDateStrBlock?
    
    /// 取消回调
    public var cancelBlock: JCVoidBlock?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupParameter()
        setupUI()
        layoutPageSubviews()
    }
    
    required public init(frame: CGRect, dateStyle: JCDateAlertEnum) {
        super.init(frame: UIScreen.main.bounds)
        
        self.dateStyle = dateStyle
        alertWidth = (dateStyle == .YMDHM) ? 3 * Constant.screenWidth / 4 : 2 * Constant.screenWidth / 3
        alertHeight = 1.1 * alertWidth 
        calanderView = JCDateViewManager.show(dateStyle)
        setupParameter()
        setupUI()
        layoutPageSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 初始化参数
    internal func setupParameter() {
        headerDesc.text = dateStyle.titleDesc
        currentDate.text = dateStyle.defaultDate
        isUserInteractionEnabled = true
        setMainColor(selectColor: mainColor)
        /// 添加事件
        confirmBtn.addTarget(self, action: .confirm, for: .touchUpInside)
        cancelBtn.addTarget(self, action: .cancel, for: .touchUpInside)
        /// 添加通知
        NotificationCenter.default.addObserver(self, selector: .dateChange, name: NSNotification.Name(rawValue: kDateChange), object: nil)
    }

    // MARK: - 内部接口
    
    /// 设置主题颜色
    internal func setMainColor(selectColor: UIColor) {
        mainColor = selectColor
        hourColon.set(selectColor, Font.dpBold(20))
        minuteColon.set(selectColor, Font.dpBold(20))
    }
    
    /// 默认设置
    internal func defaultSetup() {
        
    }
    
    /// 确认按钮
    @objc
    internal func confirmAction() {
        confirmBlock?(currentDate.text ?? "")
        confirmBlock = nil
        removeFromSuperview()
    }
    
    /// 取消按钮
    @objc
    internal func cancelAction() {
        cancelBlock?()
        cancelBlock = nil
        removeFromSuperview()
    }
    
    /// 带动画移除
    internal func alertRemoveWithAnimate() {
        UIView.animate(withDuration: 0.15, animations: {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
            self.alertView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }, completion: { (_) in
            self.removeFromSuperview()
        })
    }
    
    /// 更改日期
    @objc
    internal func dateChange(notice: Notification) {
        guard let text = notice.object as? String else { return }
        currentDate.text = text
    }
    
    // MARK: - 界面初始化
    
    /// 初始化UI
    internal func setupUI() {
        addSubview(alertView)
        alertView.addSubview(headerDesc)
        alertView.addSubview(currentDate)
        alertView.addSubview(headLine)
        alertView.addSubview(calanderView)
        alertView.addSubview(confirmBtn)
        alertView.addSubview(cancelBtn)
        alertView.addSubview(yearLine)
        alertView.addSubview(monthLine)
        alertView.addSubview(dayLine)
        alertView.addSubview(hourLine)
        alertView.addSubview(minuteLine)
        alertView.addSubview(footLine)
        alertView.addSubview(footSeparatorLine)
        alertView.addSubview(hourColon)
        alertView.addSubview(minuteColon)
    }
    
    /// 初始化布局
    internal func layoutPageSubviews() {
        alertView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(alertWidth)
            make.height.equalTo(alertHeight)
        }
        currentDate.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerDesc)
            make.bottom.equalTo(headLine.snp.top).offset(-10)
        }
        calanderView.snp.makeConstraints { (make) in
            make.left.right.equalTo(alertView)
            make.top.equalTo(headLine.snp.bottom)
            make.bottom.equalTo(footLine.snp.top)
        }
        switch dateStyle {
        case .YMDHM:
            yearLine.snp.makeConstraints { (make) in
                make.left.equalTo(alertWidth / 5)
                make.width.equalTo(1)
                make.centerY.equalTo(calanderView)
                make.height.equalTo(alertHeight - 144)
            }
            monthLine.snp.makeConstraints { (make) in
                make.left.equalTo(2 * alertWidth / 5)
                make.height.centerY.width.equalTo(yearLine)
            }
            dayLine.snp.makeConstraints { (make) in
                make.left.equalTo(3 * alertWidth / 5)
                make.height.centerY.width.equalTo(yearLine)
            }
            hourLine.snp.makeConstraints { (make) in
                make.left.equalTo(4 * alertWidth / 5)
                make.height.centerY.width.equalTo(yearLine)
            }
            break
        case .YMD:
            yearLine.snp.makeConstraints { (make) in
                make.left.equalTo(alertWidth / 3)
                make.width.equalTo(1)
                make.centerY.equalTo(calanderView)
                make.height.equalTo(alertHeight - 144)
            }
            monthLine.snp.makeConstraints { (make) in
                make.left.equalTo(2 * alertWidth / 3)
                make.height.centerY.width.equalTo(yearLine)
            }
            break
        case .YM:
            yearLine.snp.makeConstraints { (make) in
                make.left.equalTo(alertWidth / 2)
                make.width.equalTo(1)
                make.centerY.equalTo(calanderView)
                make.height.equalTo(alertHeight - 144)
            }
            break
        case .HMS:
            hourColon.snp.makeConstraints { (make) in
                make.centerY.equalTo(calanderView)
                make.centerX.equalTo(alertWidth / 3)
            }
            minuteColon.snp.makeConstraints { (make) in
                make.centerY.equalTo(calanderView)
                make.centerX.equalTo(2 * alertWidth / 3)
            }
            break
        case .HM:
            hourColon.snp.makeConstraints { (make) in
                make.centerY.equalTo(calanderView)
                make.centerX.equalTo(alertWidth / 2)
            }
            break
        }
        footLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(alertView)
            make.height.equalTo(1)
            make.bottom.equalTo(alertView).offset(-36)
        }
        footSeparatorLine.snp.makeConstraints { (make) in
            make.top.equalTo(footLine.snp.bottom)
            make.width.equalTo(1)
            make.bottom.centerX.equalTo(alertView)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(alertView)
            make.top.equalTo(footLine.snp.bottom)
            make.right.equalTo(footSeparatorLine.snp.left)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(alertView)
            make.top.equalTo(footLine.snp.bottom)
            make.left.equalTo(footSeparatorLine.snp.right)
        }
        headerDesc.snp.makeConstraints { (make) in
            make.centerX.equalTo(alertView)
            make.bottom.equalTo(alertView.snp.top).offset(40)
        }
        headLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(alertView)
            make.height.equalTo(1)
            make.top.equalTo(alertView).offset(80)
        }
    }
    
    // MARK: - 私有成员变量
    
    /// 日期显示视图对象
    var calanderView: UIView = UIView()
    
    /// 日期类型, 默认类型为年月日
    var dateStyle: JCDateAlertEnum = .YMD
    
    /// 主题颜色
    var mainColor = Color.selectedColor
    
    /// 日历的宽度
    var alertWidth: CGFloat = 0.0
    
    /// 日历的高度
    var alertHeight: CGFloat = 0.0
    
    // MARK: - 子控件
    
    /// 弹框视图
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = true
        return view
    }()
    
    /// 头描述
    private lazy var headerDesc: UILabel = {
        let label = UILabel()
        label.set(mainColor, Font.dpBold(16), .center)
        return label
    }()
    
    /// 当前年月日
    private lazy var currentDate: UILabel = {
        let label = UILabel()
        label.set(Color.hex_6, Font.dpBold(12), .center)
        return label
    }()
    
    /// 头部横线
    private let headLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.hex_E0E0E0
        return view
    }()
    
    /// 确认按钮
    public lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = Font.dp(14)
        btn.setTitleColor(Color.mainColor, for: .normal)
        return btn
    }()
    
    /// 取消按钮
    public lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = Font.dp(14)
        btn.setTitleColor(Color.hex_6, for: .normal)

        return btn
    }()
    
    /// 分割线_年
    private let yearLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 分割线_月
    private let monthLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 分割线_日
    private let dayLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 分割线_时
    private let hourLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 分割线_分
    private let minuteLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 尾部横线
    private let footLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 尾部分割线
    private let footSeparatorLine = UIView().then {
        $0.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 时分中间的冒号
    private var hourColon = UILabel().then {
        $0.text = ":"
    }
    
    /// 分秒中间的冒号
    private var minuteColon = UILabel().then {
        $0.text = ":"
    }
    
    // MARK: - 测试
}
