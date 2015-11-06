#
#  Be sure to run `pod spec lint CoreCereal.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name            = "CoreCereal"
  s.version         = "2.0.0"
  s.summary         = "A lightweight serialization framework written in Swift."
  s.description     = "For more information, please visit http://gretzlab.com/lab/cereal"


  s.homepage         = "https://github.com/jgretz/Cereal"
  s.license          = 'Apache 2.0'
  s.author           = { "Josh Gretz" => "jgretz@truefit.io" }
  s.source           = { :git => "https://github.com/jgretz/Cereal.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/joshgretz'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Cereal/**/*.{swift}'

  s.dependency 'CoreMeta'

end
