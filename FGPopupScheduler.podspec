Pod::Spec.new do |s|
  s.name         = 'FGPopupScheduler'
  s.summary      = 'iOS弹窗调度器，可以有序控制弹窗的隐藏、显示'
  s.version      = '0.3.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'FoneG' => '15757127193@163.com' }
  s.homepage     = 'https://github.com/FoneG/FGPopupScheduler'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/FoneG/FGPopupScheduler.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'FGPopupScheduler/*.{h,m,mm}'  
  s.libraries = 'c++.1'

end