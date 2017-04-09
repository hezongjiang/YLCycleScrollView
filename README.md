# YLCycleScrollView

![image](https://github.com/Hearsayer/YLCycleScrollView/blob/master/CycleScrollView.gif)


YLCycleScrollView is a delightful scrollview library for iOS, it's base on UIScrollView, use three UIImageView to achieve the effect of rolling cycle no matter how many pictures.


YLCycleScrollView是一个iOS平台下，基于UIScrollView的轻量级的滚动视图，无论多少张图片，都是用3个UIImageView来完成。


## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift, which automates and simplifies the process of using 3rd-party libraries like YLCycleScrollView in your projects.

#### Podfile

To integrate YLCycleScrollView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
target 'TargetName' do
pod 'YLCycleScrollView'
end
```


Then, run the following command:

```bash
$ pod install
```
## How to use

Add the following code where needed

```swift
// 懒加载 
lazy var cycleView: YLCycleScrollView = YLCycleScrollView(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 200))
    
//图片集合
var images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
              "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
              "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
              "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
              "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
    
override func viewDidLoad() {
    super.viewDidLoad()
        
    var datas = [CycleModel]()
        
    // 根据URL生成数据模型
    for m in images {
        datas.append(CycleModel(urlString: m))
    }
        
    // 设置数据源，数据源是'CycleModel'对象，相当于数据模型，实际开发中，建议继承'CycleModel'来设置数据
    cycleView.dataSource = datas
        
    // 设置分页控件位置
    cycleView.indicatiorPosition = .left

    // 是否显示底部阴影条
    cycleView.isShowDimBar = true
        
    // 占位图片
    cycleView.placeholderImage = UIImage(named: "3")
        
    // 代理监听图片点击
    cycleView.delegate = self
    view.addSubview(cycleView)
}
```

It is recommended that you create a class that inherits the following class(YLCycleModel) as a data source.
```swift
open class YLCycleModel: NSObject {

    /// URL字符串
    public var urlString: String 
    
    /// 文字
    public var text: String?
    
    public init(urlString: String, texts: String? = nil) {
        
        self.urlString = urlString
        
        self.text = texts
        
        super.init()
    }
}
```
