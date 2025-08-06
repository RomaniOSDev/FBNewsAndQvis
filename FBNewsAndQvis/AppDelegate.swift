//
//  AppDelegate.swift
//  FBNewsAndQvis
//
//  Created by Роман Главацкий on 19.06.2025.
//

//аккаунт - roccoweber8@icloud.com
//
//пароль - No@4m9GZXhMR2W53

import UIKit
import OneSignalFramework
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var restrictRotation: UIInterfaceOrientationMask = .all
    private let oneSignalIDCheker = OneSignalIDChecker()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AppsFlyer Init
           AppsFlyerLib.shared().appsFlyerDevKey = "CBQFw8ehRqfQCiWrKKqnhV"
           AppsFlyerLib.shared().appleAppID = "6747954089"
           AppsFlyerLib.shared().delegate = self
           AppsFlyerLib.shared().isDebug = true
           
        AppsFlyerLib.shared().start()
        let appsFlyerId = AppsFlyerLib.shared().getAppsFlyerUID()
        
        
        //MARK: - One signal
        OneSignal.initialize("17a81f8e-0b63-4236-b4b3-ced3694a211f", withLaunchOptions: nil)
        oneSignalIDCheker.startCheckingOneSignalID()
    
        OneSignal.login(appsFlyerId)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

