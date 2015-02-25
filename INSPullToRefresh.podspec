Pod::Spec.new do |s|
  s.name     = 'INSPullToRefresh'
  s.version  = '1.0.2'
  s.platform = :ios, '5.0'
  s.license  = 'MIT'
  s.summary  = 'A simple to use very generic pull-to-refresh and infinite scrolling functionalities as a UIScrollView category.'
  s.homepage = 'http://inspace.io'
  s.authors  = 'inspace.io'
  s.source   = { :git => 'https://github.com/inspace-io/INSPullToRefresh.git', :tag => '1.0.2' }
  s.source_files = ['INSPullToRefresh/*.{h,m}','INSPullToRefreshSampleControls/Default/*.{h,m}','INSPullToRefreshSampleControls/INSAnimatable.h']
  s.requires_arc = true

end
