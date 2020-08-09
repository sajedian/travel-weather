# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

source 'https://github.com/CocoaPods/Specs.git'
target 'travel-weather' do
  
  # Comment the next line if you don't want to use dynamic frameworks
  #use_frameworks!
  	pod 'JTAppleCalendar', '~> 7.1.7'
  	pod 'GooglePlaces'
	pod 'Firebase/Functions'
	pod 'Firebase/Auth'

  # Pods for travel-weather
end

target "Travel WeatherTests" do
	pod 'JTAppleCalendar', '~> 7.1.7'
end

post_install do |installer|
    copy_pods_resources_path = "Pods/Target Support Files/Pods-travel-weather/Pods-travel-weather-resources.sh"
    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
    text = File.read(copy_pods_resources_path)
    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }

    installer.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.2'
      end
    end

end

