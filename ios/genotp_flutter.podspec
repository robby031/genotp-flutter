#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint genotp_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'genotp_flutter'
  s.version          = '0.0.4'
  s.summary          = 'Flutter plugin for genotp-go OTP library via gomobile'
  s.description      = <<-DESC
Flutter plugin for genotp-go OTP library via gomobile
                       DESC
  s.homepage         = 'https://github.com/robby031/genotp-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'robby031' => 'robby031@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'genotp_flutter/Sources/genotp_flutter/**/*'
  s.vendored_frameworks = 'genotp_flutter/Genotp.xcframework'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'genotp_flutter_privacy' => ['genotp_flutter/Sources/genotp_flutter/PrivacyInfo.xcprivacy']}
end
