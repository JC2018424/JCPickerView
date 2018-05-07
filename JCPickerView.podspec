
Pod::Spec.new do |s|
s.name         = 'JCPickerView'
s.version      = '0.0.2'
s.summary      = '简单实用的字体（加粗）大小设置'
s.homepage     = 'https://github.com/JC2018424/JCPickerView'
s.license      = 'MIT'
s.authors      = {'JC' => '13451001517@163.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/JC2018424/JCPickerView.git', :tag => s.version}
s.source_files = 'JCPickerView/**/*'
s.requires_arc = true
s.framework  = "UIKit"
s.dependency "ObjectMapper", "~> 3.1"
s.dependency "Then", "~> 2.3.0"
s.dependency "SnapKit", "~> 3.2.0"

end
