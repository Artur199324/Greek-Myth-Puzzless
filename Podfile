platform :ios, '17.0' # Устанавливаем глобальную минимальную версию iOS на 17.0

use_modular_headers!

target 'Greek Myth Puzzles Powe' do
  use_frameworks!

  pod 'AppsFlyerFramework'
  pod 'SwiftShield'

  target 'Greek Myth Puzzles PoweTests' do
    inherit! :search_paths
  end

  target 'Greek Myth Puzzles PoweUITests' do
    inherit! :search_paths
  end
  

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0' # Принудительно устанавливаем на 17.0
    end
  end
end
