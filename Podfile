source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'ParkingApp' do    
  # Pods for NaverMapPI
  pod 'NMapsMap'

  # Pods for Alomofire
  pod 'Alamofire', '~> 5.2'

  # Pods for SwifyJSON
  pod 'SwiftyJSON', '~> 4.0'

  target 'ParkingAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ParkingAppUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
