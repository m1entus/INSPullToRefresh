Pod::Spec.new do |s|
  s.name     = 'INSPullToRefresh'
  s.version  = '1.2.1'
  s.platform = :ios, '5.0'
  s.license  = 'MIT'
  s.summary  = 'A simple to use very generic pull-to-refresh and infinite scrolling functionalities as a UIScrollView category.'
  s.homepage = 'http://inspace.io'
  s.authors  = 'inspace.io'
  s.source   = { :git => 'https://github.com/inspace-io/INSPullToRefresh.git', :tag => '1.2.0' }
  s.source_files = ['INSPullToRefresh/include/*.h','INSPullToRefresh/*.m']
  s.requires_arc = true

end
