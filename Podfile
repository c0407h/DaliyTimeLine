# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DaliyTimeLine' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DaliyTimeLine

  pod 'SnapKit'
  pod 'Kingfisher', '~> 7.0'
  pod 'YPImagePicker'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Auth'

  pod 'GoogleSignIn'

  pod 'FSCalendar'
  pod 'RxSwift', '6.6.0'
  pod 'RxCocoa', '6.6.0'
  pod 'RxDataSources', '~> 5.0'


  target 'DaliyTimeLineTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DaliyTimeLineUITests' do
    # Pods for testing
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
  
end
