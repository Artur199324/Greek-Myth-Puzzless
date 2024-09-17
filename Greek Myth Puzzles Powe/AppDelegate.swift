import SwiftUI
import Foundation
import UIKit
import AppsFlyerLib
import AppTrackingTransparency
import AdSupport
import FacebookCore
import FacebookShare


// AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate, AppsFlyerLibDelegate, DeepLinkDelegate {
    var dataModel = DataModel()
    // Переменные для хранения значений из deep_link_value, инициализированы значением "null"
    var value1: String? = "null"
    var value2: String? = "null"
    var value3: String? = "null"
    var value4: String? = "null"
    var value5: String? = "null"
    var value6: String? = "null"
    var value7: String? = "null"

    var dvalue1: String? = "null"
    var dvalue2: String? = "null"
    var dvalue3: String? = "null"
    var dvalue4: String? = "null"
    var dvalue5: String? = "null"
    var dvalue6: String? = "null"
    var dvalue7: String? = "null"
    // Переменные для хранения значений из Remote Config
    var checkAdv: String = "null"
    var newUser: Bool = false
    
    var idfa: String = "null"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
       
       

        // Инициализация Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        // Установка настроек Facebook SDK
        Settings.shared.isAutoLogAppEventsEnabled = true
        Settings.shared.isAdvertiserIDCollectionEnabled = true

    

        // AppsFlyer конфигурация
        AppsFlyerLib.shared().appsFlyerDevKey = "xst98jJKqjFmAFtJdcvJvK" // Укажите ваш Dev Key
        AppsFlyerLib.shared().appleAppID = "6670722073"    // Укажите ваш App Store ID без "id"
        AppsFlyerLib.shared().isDebug = true                  // Включите debug режим для отладки

        // Устанавливаем делегата для AppsFlyer
        AppsFlyerLib.shared().delegate = self

        // Устанавливаем делегат для глубоких ссылок
        AppsFlyerLib.shared().deepLinkDelegate = self

        // Настраиваем ожидание ответа на запрос ATT
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)

        // Добавляем наблюдатель для UIApplication.didBecomeActiveNotification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActiveNotification),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)

        // Запуск AppsFlyer SDK
        AppsFlyerLib.shared().start()

        return true
    }

    @objc func didBecomeActiveNotification() {
        // Проверка текущего статуса разрешения на отслеживание
        checkTrackingAuthorizationStatusAndHandleFacebookAndIDFA()
    }

    // Функция для проверки статуса разрешения на отслеживание и обработки диплинков Facebook и получения IDFA
    private func checkTrackingAuthorizationStatusAndHandleFacebookAndIDFA() {
        if #available(iOS 14, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
            case .authorized:
                // Устанавливаем isAdvertiserTrackingEnabled в true
                Settings.shared.isAdvertiserTrackingEnabled = true
                print("ATT статус: авторизовано")
                // Получаем IDFA после разрешения
                idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
             
                // Обработка deferred deep links от Facebook
                fetchDeferredAppLink()
            case .denied, .restricted:
                // Устанавливаем isAdvertiserTrackingEnabled в false
                Settings.shared.isAdvertiserTrackingEnabled = false
                print("ATT статус: запрещено или ограничено")
            case .notDetermined:
                // Запрос разрешения, если статус не определён
                print("ATT статус: не определён")
                requestTrackingAuthorization()
            @unknown default:
                fatalError("Неверный статус авторизации.")
            }
        } else {
            // Для iOS ниже 14 версии
            idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            // Обработка deferred deep links от Facebook
            fetchDeferredAppLink()
        }
    }

    // Запрос разрешения на отслеживание для iOS 14 и выше
    private func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { [self] status in
            switch status {
            case .authorized:
                // Устанавливаем isAdvertiserTrackingEnabled в true
                Settings.shared.isAdvertiserTrackingEnabled = true
                print("ATT статус после запроса: авторизовано")
                idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            
                // Обработка deferred deep links от Facebook
                self.fetchDeferredAppLink()
            case .denied, .restricted:
                // Устанавливаем isAdvertiserTrackingEnabled в false
                Settings.shared.isAdvertiserTrackingEnabled = false
                print("ATT статус после запроса: запрещено или ограничено")
            case .notDetermined:
                // Пользователь не сделал выбор
                print("ATT статус после запроса: не определён")
            @unknown default:
                fatalError("Неверный статус авторизации.")
            }
        }
    }

    // Функция для загрузки отложенного диплинка
    private func fetchDeferredAppLink() {
        print("Загрузка отложенного диплинка")
        AppLinkUtility.fetchDeferredAppLink { [self] appLink, error in
            if let error = error {
                print("Ошибка при получении диплинка: \(error.localizedDescription)")
            } else if let appLink = appLink {
               
                let deepLinkValue = appLink.absoluteString.replacingOccurrences(of: "://", with: "")
                let values = deepLinkValue.split(separator: "_").map { String($0) }
                self.dvalue1 = values.indices.contains(0) ? values[0] : "null"
                self.dvalue2 = values.indices.contains(1) ? values[1] : "null"
                self.dvalue3 = values.indices.contains(2) ? values[2] : "null"
                self.dvalue4 = values.indices.contains(3) ? values[3] : "null"
                self.dvalue5 = values.indices.contains(4) ? values[4] : "null"
                self.dvalue6 = values.indices.contains(5) ? values[5] : "null"
                self.dvalue7 = values.indices.contains(6) ? values[6] : "null"
            
            } else {
                print("Диплинк отсутствует или ошибка")
            }
        }
    }

    // MARK: - AppsFlyerLibDelegate Methods
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
        // Обработка данных атрибуции AppsFlyer
        if let status = conversionInfo["af_status"] as? String {
           
            if status == "Non-organic" {
                if let sourceID = conversionInfo["media_source"],
                   let campaign = conversionInfo["campaign"] {
                    print("Это неорганическая установка. Источник: \(sourceID), Кампания: \(campaign)")
                }
                addData()
                
            } else {
                print("Это органическая установка.")
                addData()
            }
        }

        // Получение значения deep_link_value из атрибуции
//        if let deepLinkValue = conversionInfo["deep_link_value"] as? String {
//            print("Deep Link Value: \(deepLinkValue)")
//            // Разбиваем deep_link_value по символу "_"
//            let values = deepLinkValue.split(separator: "_").map { String($0) }
//
//            // Присваиваем значения переменным
//            value1 = values.indices.contains(0) ? values[0] : "null"
//            value2 = values.indices.contains(1) ? values[1] : "null"
//            value3 = values.indices.contains(2) ? values[2] : "null"
//            value4 = values.indices.contains(3) ? values[3] : "null"
//            value5 = values.indices.contains(4) ? values[4] : "null"
//            value6 = values.indices.contains(5) ? values[5] : "null"
//            value7 = values.indices.contains(6) ? values[6] : "null"
//            addData()
//        } else {
//            // Если deep_link_value отсутствует, печатаем исходные значения
//            print("Deep Link Value отсутствует или имеет некорректный формат.")
//        }
    }

    func onConversionDataFail(_ error: Error) {
        print("Ошибка при получении данных конверсии: \(error.localizedDescription)")
        addData()
    }

    // MARK: - AppsFlyerDeepLinkDelegate Methods
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            print("Диплинк найден: \(result.deepLink?.deeplinkValue ?? "Нет значения диплинка")")
            if let deepLinkValue = result.deepLink?.deeplinkValue {
                let values = deepLinkValue.split(separator: "_").map { String($0) }
                value1 = values.indices.contains(0) ? values[0] : "null"
                value2 = values.indices.contains(1) ? values[1] : "null"
                value3 = values.indices.contains(2) ? values[2] : "null"
                value4 = values.indices.contains(3) ? values[3] : "null"
                value5 = values.indices.contains(4) ? values[4] : "null"
                value6 = values.indices.contains(5) ? values[5] : "null"
                value7 = values.indices.contains(6) ? values[6] : "null"
                addData()
            }
        case .notFound:
            print("Диплинк не найден")
            addData()
        case .failure:
            print("Ошибка при получении диплинка: \(result.error?.localizedDescription ?? "Неизвестная ошибка")")
            addData()
        @unknown default:
            print("Неизвестный статус диплинка")
            addData()
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        AppsFlyerLib.shared().handleOpen(url, options: options)
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Не удалось зарегистрироваться для удаленных уведомлений: \(error.localizedDescription)")
        addData()
    }
    
    
    func addData() {
        // Приведение опциональных значений к строкам
        let v1 = value1 ?? "null"
        let v2 = value2 ?? "null"
        let v3 = value3 ?? "null"
        let v4 = value4 ?? "null"
        let v5 = value5 ?? "null"
        let v6 = value6 ?? "null"
        let v7 = value7 ?? "null"
        
        let dv1 = dvalue1 ?? "null"
        let dv2 = dvalue2 ?? "null"
        let dv3 = dvalue3 ?? "null"
        let dv4 = dvalue4 ?? "null"
        let dv5 = dvalue5 ?? "null"
        let dv6 = dvalue6 ?? "null"
        let dv7 = dvalue7 ?? "null"
        
        self.dataModel.newUser = true
        let add = "https://celestialcirdscuit.com/fDwcdwBc?sub1=\(v1)&sub2=\(v2)&sub3=\(v3)&sub4=\(v4)&sub5=\(v5)&sub6=\(v6)&sub7=\(v7)&deep1=\(dv1)&deep2=\(dv2)&deep3=\(dv3)&deep4=\(dv4)&deep5=\(dv5)&deep6=\(dv6)&deep7=\(dv7)&gadid=\(idfa)"
        self.dataModel.add = add
      
    }
}
