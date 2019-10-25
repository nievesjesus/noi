#
# Be sure to run `pod lib lint noi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Noi'
  s.version          = '0.1.0'
  s.summary          = 'Lite HTTP RestClient for JSON responses'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "Another restclient to use with your RestApi"
  s.homepage         = 'https://github.com/nievesjesus/noi'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jesus Nieves' => 'yo@nievesjesus.com' }
  s.source           = { :git => 'https://github.com/nievesjesus/noi.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nievesjesus'
  s.swift_version    = '4.2'
  s.ios.deployment_target = '8.0'

  s.source_files = 'Noi/Classes/**/*'
  
  # s.resource_bundles = {
  #   'noi' => ['noi/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
