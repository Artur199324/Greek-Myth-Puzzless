# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

use_modular_headers!

target 'Greek Myth Puzzles Powe' do
  # Комментируем следующую строку для использования статических библиотек
  use_frameworks!

  # Добавляем OneSignalXCFramework в основной таргет
  pod 'OneSignalXCFramework', '>= 3.0.0', '< 4.0'

  # Добавляем AppsFlyer SDK
  pod 'AppsFlyerFramework'

  # Ваши другие Pods здесь

  target 'Greek Myth Puzzles PoweTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Greek Myth Puzzles PoweUITests' do
    inherit! :search_paths
    # Pods для UI-тестирования
  end
  
  target 'OneSignalNotificationServiceExtension' do
    # Комментируем следующую строку для использования статических библиотек
    use_frameworks!

    # Добавляем OneSignalXCFramework для расширения уведомлений
    pod 'OneSignalXCFramework', '>= 3.0.0', '< 4.0'
  end
end