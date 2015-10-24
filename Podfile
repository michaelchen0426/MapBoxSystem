platform :ios, ‘8.1’
pod 'GoogleMaps'
pod 'SVProgressHUD', :head
pod 'Mapbox-iOS-SDK'
use_frameworks!

# disable bitcode in every sub-target
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end