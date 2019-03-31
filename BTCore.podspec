Pod::Spec.new do |s|
  s.name             = "BTCore"
  s.version          = "0.0.6"
  s.summary          = "iOS Project Basic"
  s.homepage         = "https://github.com/StoneMover/BTCore"
  s.license          = 'MIT'
  s.author           = {"StoneMover" => "stonemover@163.com"}
  s.platform         = :ios, '9.0'
  s.source           = {:git => "https://github.com/StoneMover/BTCore.git", :tag => s.version }
  s.source_files     = 'Classes/**/*.{h,m}'
  s.requires_arc     = true
  s.dependency 'RTRootNavigationController'
  s.dependency 'AFNetworking'
  s.dependency 'MJRefresh'
  s.dependency 'BTLoading'
  s.dependency 'BTHelp'
end