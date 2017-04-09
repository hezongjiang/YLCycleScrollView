//
//  YLCycleImageView.swift
//  YLCycleScrollView
//
//  Created by he on 2017/4/8.
//  Copyright © 2017年 he. All rights reserved.
//

import UIKit

enum TextLabelPosition {
    case left
    case right
    case none
}

class YLCycleImageView: UIImageView {

    
    /// 阴影条
    private lazy var dimBar: UIView = UIView()
    
    /// 文字标签
    private lazy var textLabel: UILabel = UILabel()
    
    var dimBarHeight: CGFloat = 30
    
    /// 是否显示阴影条
    var isShowDimBar: Bool = true {
        didSet {
            dimBar.isHidden = !isShowDimBar
        }
    }
    
    /// 文字
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    /// 文字标签位置
    var textLabelPosition: TextLabelPosition = .none{
        didSet {
            switch textLabelPosition {
            case .right:
                textLabel.isHidden = false
                textLabel.frame = CGRect(x: frame.width - indicatorWidth - margin * 2, y: 0, width: frame.width - indicatorWidth - margin * 3, height: dimBarHeight)
            case .left:
                textLabel.isHidden = false
                textLabel.frame = CGRect(x: margin, y: 0, width: frame.width - indicatorWidth - margin * 3, height: dimBarHeight)
            case .none:
                textLabel.isHidden = true
            }
        }
    }
    
    init() {
        super.init(frame: CGRect())
        dimBar.isHidden = true
        dimBar.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(dimBar)
        
        textLabel.textColor = UIColor.white
        dimBar.addSubview(textLabel)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = frame.width
        
        let height = frame.height
        
        guard width > 1 && height > 1 else { return }
        
        dimBar.frame = CGRect(x: 0, y: height - dimBarHeight, width: width, height: dimBarHeight)
    }
}
