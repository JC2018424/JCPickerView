//
//  JCTableViewCell.swift
//  JCPopularPro
//
//  Created by 严伟 on 2018/1/18.
//  Copyright © 2018年 yW. All rights reserved.
//

import UIKit

class JCTableViewCell: UITableViewCell {
    
    /// 设置标题
    ///
    /// - Parameter description: 标题
    public func setTitle(with description: String) {
        titleLabel.text = description
    }
    
    /// 设置左侧图像
    ///
    /// - Parameter descImage: 图片
    public func setTitleImage(with descImage: UIImage) {
        leftImageView.image = descImage
    }
    
    /// 设置右侧图像
    ///
    /// - Parameter enterImage: 图片
    public func setEnterImage(with enterImage: UIImage) {
        rightImageView.image = enterImage
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupParameter()
        setupUI()
        layoutPageSubviews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupParameter()
        setupUI()
        layoutPageSubviews()
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // 保证点击时分隔线颜色不变
        separatorLine.backgroundColor = Color.hex_E0E0E0
    }
    
    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        // 保证点击时分隔线颜色不变
        separatorLine.backgroundColor = Color.hex_E0E0E0
    }
    
    /// 左侧图像
    fileprivate let leftImageView = UIImageView()
    
    /// 右侧图像
    fileprivate let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "list_btn_enterarrow")
        return imageView
    }()
    
    /// 分隔线
    fileprivate let separatorLine: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.hex_E0E0E0
        return imageView
    }()
    
    /// 内容
    fileprivate let titleLabel = UILabel()
    
    /// 参数设置
    internal func setupParameter() {
        selectionStyle = .none
    }
    
    /// 添加控件
    internal func setupUI() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(separatorLine)
    }
    
    /// 布局
    internal func layoutPageSubviews() {
        leftImageView.snp.makeConstraints { (make) in
            make.left.top.height.equalTo(self)
            make.width.equalTo(self.snp.height)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right)
            make.height.centerY.equalTo(self)
        }
        rightImageView.snp.makeConstraints { (make) in
            make.right.top.height.equalTo(self)
            make.width.equalTo(self.snp.height)
        }
        separatorLine.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.height.equalTo(0.5)
        }
    }
}

public extension UITableView {
    
    public func registerReusableCell<T: UITableViewCell>(withIdentifier: String, type: T.Type) {
        register(type, forCellReuseIdentifier: withIdentifier)
    }
    
    public func registerReusableCell<T: UITableViewCell>(with type: T.Type) {
        registerReusableCell(withIdentifier: "\(type.self)", type: type)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(withIdentifier: String, type: T.Type, style: UITableViewCellStyle = .default) -> T {
        return (dequeueReusableCell(withIdentifier: withIdentifier) as? T) ?? T(style: style, reuseIdentifier: withIdentifier)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, style: UITableViewCellStyle = .default) -> T {
        return dequeueReusableCell(withIdentifier: "\(type.self)", type: type, style: style)
    }
}
