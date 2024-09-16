//
//  Olympus_Glory_Divine_PoweApp.swift
//  Olympus Glory Divine Powe
//
//  Created by Artur on 02.09.2024.
//

import SwiftUI
let initialValue = 500

@main
struct Olympus_Glory_Divine_PoweApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            
            ContentView().environmentObject(appDelegate.dataModel)
        }
    }
}
