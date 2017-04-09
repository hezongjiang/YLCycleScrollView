//
//  ViewController.swift
//  YLCycleScrollDemo
//
//  Created by Hearsay on 2017/3/1.
//  Copyright © 2017年 Hearsay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var v: YLCycleScrollView = YLCycleScrollView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 200))
    
    
    //图片集合
    var images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
                  "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                  "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                  "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
                  "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var datas = [YLCycleModel]()
        
        for m in images {
            datas.append(YLCycleModel(urlString: m))
        }
        
        v.dataSource = datas
        v.indicatiorPosition = .left
        v.placeholderImage = UIImage(named: "3")
        v.delegate = self
        view.addSubview(v)
    }
}

extension ViewController: CycleScrollViewDelegate {
    
    func cycleScrollView(_ YLCycleScrollView: YLCycleScrollView, didTap index: Int, data: YLCycleModel) {
        print(data)
    }
}
