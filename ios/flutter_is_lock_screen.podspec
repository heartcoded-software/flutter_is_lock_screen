#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_is_lock_screen.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_is_lock_screen'
  s.version          = '3.0.2'
  s.summary          = 'Detects if device is in lock screen.'
  s.description      = <<-DESC
Detects if device is in lock screen. Useful for determining whether app entered background due to locking screen or leaving app.
                       DESC
  s.homepage         = 'https://github.com/heartcoded-software/flutter_is_lock_screen'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'heartcoded software gmbh' => 'office@heartcoded-software.de' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flutter_is_lock_screen_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
