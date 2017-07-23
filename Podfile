# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Stoxxx' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Stoxxx
  pod 'DGElasticPullToRefresh'  
  pod 'RealmSwift'  
  pod 'Reactions', '~> 1.1.1'
  pod 'SwiftVideoBackground'
  pod 'Charts'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Hexacon'
  pod "JDropDownAlert"
  target 'StoxxxTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'StoxxxUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end