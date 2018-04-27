//
//  ViewController.swift
//  JCPickerView
//
//  Created by 严伟 on 2018/4/24.
//  Copyright © 2018年 yW. All rights reserved.
//

import UIKit

///
public class ViewController: UIViewController {
    
    // MARK: - 公共成员变量
    
    // MARK: - 生命周期
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupParameter()
        setupUI()
        layoutPageSubviews()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 界面初始化
    
    
    /// 初始化UI
    fileprivate func setupUI() {
        view.addSubview(tableView)
    }
    
    /// 初始化布局
    fileprivate func layoutPageSubviews() {
        tableView.frame = CGRect(x: 0, y: 0, width: Constant.screenWidth,
                                 height: Constant.screenHeight)
    }
    
    /// 初始化参数
    fileprivate func setupParameter() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - 内部接口
    
    // MARK: - 私有成员变量
    
    /// 数据源
    private let sourseArr: [String] = ["年月日时分", "年月日", "年月", "时分秒", "时分"]
    
    // MARK: - 子控件
    
    /// 列表项
    private let tableView = UITableView().then {
        $0.rowHeight = 60
    }
    
    // MARK: - 测试
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourseArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: JCTableViewCell.self)
        cell.setTitle(with: sourseArr[indexPath.row])
        cell.setEnterImage(with:  UIImage(named: "my_enter_btn")!)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let style = JCDateAlertEnum(rawValue: indexPath.row) else { return }
        JCPickerView.show(confirmBlock: { (date) in
            print("date = \(date)")
        }, dateStyle: style)
    }
}
