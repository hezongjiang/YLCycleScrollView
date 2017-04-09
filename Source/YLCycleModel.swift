//
//  YLCycleModel.swift
//  YLCycleScrollView
//
//  Created by he on 2017/4/8.
//  Copyright © 2017年 he. All rights reserved.
//

import UIKit

open class YLCycleModel: NSObject {

    /// URL字符串
    public var urlString: String {
        didSet {
            url = URL(string: urlString)
        }
    }
    
    /// 文字
    public var text: String?
    
    var url: URL?
    
    
    public init(urlString: String, texts: String? = nil) {
        
        self.urlString = urlString
        
        self.text = texts
        
        url = URL(string: urlString)
        
        super.init()
    }
}
