#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint momo_vn.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'momo_vn'
  s.version          = '0.0.1'
  s.summary          = 'MoMo Pluign'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://minhvn.met'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Minh Vo' => 'minhvo.me@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
