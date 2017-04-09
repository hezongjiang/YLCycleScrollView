
Pod::Spec.new do |s|

    s.name         = "YLCycleScrollView"
    s.version      = "1.2.1"
    s.summary      = "无限滚动视图"
    s.homepage     = "https://github.com/Hearsayer/YLCycleScrollView"
    s.license      = "MIT"
    s.author             = { "Hearsayer" => "email@address.com" }
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/Hearsayer/YLCycleScrollView.git", :tag => "#{s.version}" }
    s.source_files  = "Source/*.{swift}"
    s.requires_arc = true
    s.dependency "Kingfisher"

end
