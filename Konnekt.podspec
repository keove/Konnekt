#
# Be sure to run `pod lib lint Konnekt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Konnekt'
  s.version          = '1.1.2'
  s.summary          = 'Http request ez-mode'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Make http post,get request easily with a single in-line call-back. Allows making multi-part form request with form parameters and file upload too.'

  s.homepage         = 'https://github.com/keove/Konnekt'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cozdes' => 'cagri.ozdes@keove.com' }
  s.source           = { :git => 'https://github.com/keove/Konnekt.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Konnekt/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Konnekt' => ['Konnekt/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
