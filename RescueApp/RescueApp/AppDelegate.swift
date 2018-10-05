//
//  AppDelegate.swift
//  RescueApp
//
//  Created by Jayahari Vavachan on 8/17/18.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var filterModel:FilterModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        FirebaseAPIConfigure.shared.configure()
        
        saveDefaultEmergencyMessages()
        // The default language of the app is English
        UserDefaults.standard.set(Language.english.rawValue, forKey: Constants.UserDefaultsKeys.PREFERRED_LANGUAGE)
        return true
    }
    
    private func saveDefaultEmergencyMessages() {
        UserDefaults.standard.set(Constants.DANGER_NEED_HELP_MESSAGE,
                                  forKey: Constants.UserDefaultsKeys.DANGER_NEED_HELP_MESSAGE)
        UserDefaults.standard.set(Constants.MARK_AS_SAFE_MESSAGE,
                                  forKey: Constants.UserDefaultsKeys.MARK_AS_SAFE_MESSAGE)
    }
}

