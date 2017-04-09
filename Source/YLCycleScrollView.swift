//
//  YLCycleScrollView.swift
//  YLCycleScrollView
//
//  Created by he on 2017/4/7.
//  Copyright © 2017年 he. All rights reserved.
//

import UIKit
import Kingfisher

@objc protocol cycleScrollViewDelegate {
    
    func cycleScrollView(_ YLCycleScrollView: YLCycleScrollView, didTap index: Int, data: YLCycleModel)
}

public enum IndicatiorPositionType {
    case right
    case middle
    case left
}

let margin: CGFloat = 10

let indicatorWidth: CGFloat = 120
let indicatorHeight: CGFloat = 30

public class YLCycleScrollView: UIView {
    /// 代理
    weak var delegate: cycleScrollViewDelegate?
    
    /// 图片内容模式
    public var imageContentMode: UIViewContentMode = .scaleToFill {
        didSet {
            for imageView in imageViews {
                imageView.contentMode = imageContentMode
            }
        }
    }
    
    /// 占位图片（用来当iamgeView还没将图片显示出来时，显示的图片）
    public var placeholderImage: UIImage? {
        didSet {
            resetImageViewSource()
        }
    }
    
    /// 数据源，URL字符串
    public var dataSource : [YLCycleModel]? {
        didSet {
            
            guard let dataSource = dataSource, dataSource.count > 0 else { return }
            
            resetImageViewSource()
            
            //设置页控制器
            configurePageController()
        }
    }
    
    /// 滚动间隔时间，默认3秒
    public var intervalTime: TimeInterval = 3 {
        didSet {
            invalidate()
            configureAutoScrollTimer(intervalTime)
        }
    }
    
    /// 分页控件位置
    public var indicatiorPosition: IndicatiorPositionType = .middle {
        didSet {
            
            for imageView in scrollerView.subviews as! [YLCycleImageView] {
                switch indicatiorPosition {
                case .left:
                    imageView.textLabelPosition = .right
                case .middle:
                    imageView.textLabelPosition = .none
                case .right:
                    imageView.textLabelPosition = .left
                }
            }
            
            switch indicatiorPosition {
            case .left:
                pageControl.frame = CGRect(x: margin, y: scrollerViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
                
            case .right:
                pageControl.frame = CGRect(x: scrollerViewWidth - indicatorWidth - margin, y: scrollerViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
            case .middle:
                pageControl.frame = CGRect(x: (scrollerViewWidth - indicatorWidth) * 0.5, y: scrollerViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
            }
        }
    }
    
    /// 分页控件圆点颜色
    public var pageIndicatorTintColor: UIColor? {
        didSet {
            pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    /// 分页控件当前圆点颜色
    public var currentPageIndicatorTintColor: UIColor? {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    
    /// 是否显示底部阴影栏
    public var isShowDimBar: Bool = false {
        didSet {
            for view in scrollerView.subviews as! [YLCycleImageView] {
                view.isShowDimBar = isShowDimBar
            }
        }
    }
    
    /// 当前展示的图片索引
    fileprivate var currentIndex : Int = 0
    
    /// 图片辅助属性，把传进来的URL字符串转成URL对象
    //    fileprivate lazy var imagesURL = [URL]()
    
    /// 用于轮播的左中右三个image（不管几张图片都是这三个imageView交替使用）
    fileprivate lazy var leftImageView: YLCycleImageView = YLCycleImageView()
    fileprivate lazy var middleImageView: YLCycleImageView = YLCycleImageView()
    fileprivate lazy var rightImageView: YLCycleImageView = YLCycleImageView()
    
    fileprivate var imageViews: [YLCycleImageView] {
        return [leftImageView, middleImageView, rightImageView]
    }
    
    /// 放置imageView的滚动视图
    private lazy var scrollerView = UIScrollView()
    
    /// scrollView的宽
    fileprivate var scrollerViewWidth: CGFloat = 0
    /// scrollView的高
    fileprivate var scrollerViewHeight: CGFloat = 0
    
    /// 页控制器（小圆点）
    fileprivate lazy var pageControl = UIPageControl()
    
    /// 自动滚动计时器
    fileprivate var autoScrollTimer: Timer?
    
    
    public init(frame: CGRect, placeholder: UIImage? = nil) {
        
        super.init(frame: frame)
        
        scrollerViewWidth = frame.size.width
        scrollerViewHeight = frame.size.height
        
        //设置scrollerView
        configureScrollerView()
        
        
        
        //设置加载指示图片
        //        configurePlaceholder(placeholder)
        //设置imageView
        configureImageView()
        //设置自动滚动计时器
        configureAutoScrollTimer()
        
        backgroundColor = UIColor.black
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置scrollerView
    private func configureScrollerView(){
        
        scrollerView.frame = CGRect(x: 0,y: 0, width: scrollerViewWidth, height: scrollerViewHeight)
        //        scrollerView.backgroundColor = UIColor.red
        scrollerView.delegate = self
        scrollerView.contentSize = CGSize(width: scrollerViewWidth * 3, height: 0)
        //滚动视图内容区域向左偏移一个view的宽度
        scrollerView.contentOffset = CGPoint(x: scrollerViewWidth, y: 0)
        scrollerView.showsVerticalScrollIndicator = false
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.isPagingEnabled = true
        scrollerView.bounces = false
        addSubview(scrollerView)
    }
    
    /// 设置占位图片图片
    //    private func configurePlaceholder(_ placeholder: UIImage?){
    //        //这里使用ImageHelper将文字转换成图片，作为加载指示符
    //        if placeholder == nil {
    //
    //            let font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightMedium)
    //            let size = CGSize(width: scrollerViewWidth, height: scrollerViewHeight)
    //            placeholderImage = UIImage(text: "图片加载中...", font:font, color:UIColor.white, size:size)!
    //        } else {
    //            placeholderImage = placeholder
    //        }
    //    }
    
    /// 设置imageView
    func configureImageView(){
        
        
        for (i, imageView) in imageViews.enumerated() {
            
            imageView.frame = CGRect(x: CGFloat(i) * scrollerViewWidth, y: 0, width: scrollerViewWidth, height: scrollerViewHeight)
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:))))
            scrollerView.addSubview(imageView)
        }
        
        //        leftImageView.frame = CGRect(x: 0, y: 0, width: scrollerViewWidth, height: scrollerViewHeight)
        //        middleImageView.frame = CGRect(x: scrollerViewWidth, y: 0, width: scrollerViewWidth, height: scrollerViewHeight)
        //        rightImageView.frame = CGRect(x: 2 * scrollerViewWidth, y: 0, width: scrollerViewWidth, height: scrollerViewHeight)
        //
        //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        resetImageViewSource()
        
        //        scrollerView.addSubview(leftImageView)
        //        scrollerView.addSubview(middleImageView)
        //        scrollerView.addSubview(rightImageView)
        
        //        leftImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:))))
        //        middleImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:))))
        //        rightImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap(tap:))))
    }
    
    @objc private func imageTap(tap: UITapGestureRecognizer) {
        
        if dataSource != nil && dataSource!.count > 0 && currentIndex < dataSource!.count {
            
            delegate?.cycleScrollView(self, didTap: currentIndex, data: dataSource![currentIndex])
        }
        
    }
    
    /// 设置页控制器
    private func configurePageController() {
        
        pageControl.frame = CGRect(x: (scrollerViewWidth - indicatorWidth) * 0.5, y: scrollerViewHeight - indicatorHeight, width: indicatorWidth, height: indicatorHeight)
        pageControl.numberOfPages = dataSource?.count ?? 0
        pageControl.isUserInteractionEnabled = false
        addSubview(pageControl)
    }
    
    /// 设置自动滚动计时器
    fileprivate func configureAutoScrollTimer(_ time: TimeInterval = 3) {
        
        autoScrollTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(letItScroll), userInfo: nil, repeats: true)
    }
    
    fileprivate func invalidate() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    /// 计时器时间一到，滚动一张图片
    @objc fileprivate func letItScroll(){
        let offset = CGPoint(x: 2 * scrollerViewWidth, y: 0)
        scrollerView.setContentOffset(offset, animated: true)
    }
    
    /// 每当滚动后重新设置各个imageView的图片
    fileprivate func resetImageViewSource() {
        
        guard let dataSource = dataSource, dataSource.count > 0 else { return }
        
        let first = dataSource.first
        let last = dataSource.last
        
        
        //当前显示的是第一张图片
        if currentIndex == 0 {
            setupImageView(leftImageView, image: last?.url, text: last?.text)
            setupImageView(middleImageView, image: first?.url, text: first?.text)
            
            let rightImageIndex = (dataSource.count) > 1 ? 1 : 0 //保护
            setupImageView(rightImageView, image: dataSource[rightImageIndex].url, text: dataSource[rightImageIndex].text)
        }
            //当前显示的是最好一张图片
        else if currentIndex == dataSource.count - 1 {
            setupImageView(leftImageView, image: dataSource[currentIndex - 1].url, text: dataSource[currentIndex - 1].text)
            setupImageView(middleImageView, image: last?.url, text: last?.text)
            setupImageView(rightImageView, image: first?.url, text: first?.text)
        }
            //其他情况
        else{
            setupImageView(leftImageView, image: dataSource[currentIndex-1].url, text: dataSource[currentIndex-1].text)
            setupImageView(middleImageView, image: dataSource[currentIndex].url, text: dataSource[currentIndex].text)
            setupImageView(rightImageView, image: dataSource[currentIndex+1].url, text: dataSource[currentIndex+1].text)
        }
    }
    
    private func setupImageView(_ imageView: YLCycleImageView, image: URL?, text: String?) {
        imageView.kf.setImage(with: image, placeholder: placeholderImage, options: [.transition(.fade(1))])
        imageView.text = text
    }
}

// MARK: - UIScrollViewDelegate
extension YLCycleScrollView: UIScrollViewDelegate {
    
    // 自动滚动
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        guard let dataSource = dataSource, dataSource.count > 0 else { return }
        
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        //如果向左滑动（显示下一张）
        if (offset >= scrollerViewWidth * 2) {
            //还原偏移量
            scrollView.contentOffset = CGPoint(x: scrollerViewWidth, y: 0)
            //视图索引+1
            currentIndex = currentIndex + 1
            
            if currentIndex == dataSource.count { currentIndex = 0 }
        }
        
        //如果向右滑动（显示上一张）
        if offset <= 0 {
            //还原偏移量
            scrollView.contentOffset = CGPoint(x: scrollerViewWidth, y: 0)
            //视图索引-1
            currentIndex = currentIndex - 1
            
            if currentIndex == -1 { currentIndex = dataSource.count - 1 }
        }
        
        //重新设置各个imageView的图片
        resetImageViewSource()
        //设置页控制器当前页码
        pageControl.currentPage = currentIndex
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewWillBeginDecelerating(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewWillBeginDecelerating(scrollView)
    }
    
    //手动拖拽滚动开始
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewWillBeginDecelerating(scrollView)
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        invalidate()
    }
    
    //手动拖拽滚动结束
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configureAutoScrollTimer()
        scrollViewWillBeginDecelerating(scrollView)
    }
}
