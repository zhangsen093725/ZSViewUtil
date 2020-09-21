#
# Be sure to run `pod lib lint ZSViewUtil.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ZSViewUtil'
    s.version          = '0.7.0'
    s.summary          = '自定义 View'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    包含 Web、Toast、Animation、Player等等
    DESC
    
    s.homepage         = 'https://github.com/zhangsen093725/ZSViewUtil'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'zhangsen093725' => '376019018@qq.com' }
    s.source           = { :git => 'https://github.com/zhangsen093725/ZSViewUtil.git', :tag => s.version.to_s }
    s.swift_version    = '5.0'
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    s.default_subspecs = 'All'
    
    s.subspec 'All' do |a|
        a.source_files = 'ZSViewUtil/Classes/**/*'
        s.resource_bundles = {
            'ZSViewUtil' => ['ZSViewUtil/Assets/**/*']
        }
    end
    
    s.subspec 'Button' do |b|
        b.source_files = 'ZSViewUtil/Classes/Button/**/*'
    end
    
    s.subspec 'CollectionView' do |c|
        c.source_files = 'ZSViewUtil/Classes/CollectionView/**/*'
    end
    
    s.subspec 'DragView' do |d|
        d.source_files = 'ZSViewUtil/Classes/DragView/**/*'
    end
    
    s.subspec 'Extension' do |e|
        e.source_files = 'ZSViewUtil/Classes/Extension/**/*'
    end
    
    s.subspec 'Field' do |f|
        f.source_files = 'ZSViewUtil/Classes/Field/**/*'
    end
    
    s.subspec 'Image' do |i|
        i.source_files = 'ZSViewUtil/Classes/Image/**/*'
    end
    
    s.subspec 'Layout' do |l|
        l.source_files = 'ZSViewUtil/Classes/Layout/**/*'
    end
    
    s.subspec 'Layer' do |ly|
        ly.source_files = 'ZSViewUtil/Classes/Layer/**/*'
    end
    
    s.subspec 'Player' do |p|
        p.source_files = 'ZSViewUtil/Classes/Player/**/*'
    end
    
    s.subspec 'Shadow' do |ss|
        ss.source_files = 'ZSViewUtil/Classes/Shadow/**/*'
    end
    
    s.subspec 'Toast' do |t|
        t.source_files = 'ZSViewUtil/Classes/Toast/**/*'
    end
    
    s.subspec 'TableView' do |tb|
        tb.source_files = 'ZSViewUtil/Classes/TableView/**/*'
    end
    
    s.subspec 'ViewAnimation' do |v|
        v.source_files = 'ZSViewUtil/Classes/ViewAnimation/**/*'
    end
    
    s.subspec 'WebView' do |w|
        w.source_files = 'ZSViewUtil/Classes/WebView/**/*'
    end
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
end
