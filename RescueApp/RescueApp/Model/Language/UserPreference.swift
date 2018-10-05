//
//  LanguagePreference.swift
//  RescueApp
//
//  Created by Vasily Ptitsyn on 05/10/2018.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import Foundation


class UserPreference<Entity: UserDefaultable> {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}

extension UserPreference {
    var preference: Entity {
        get {
            guard let result = userDefaults.object(forKey: Entity.userDefaultsKey) as? Entity else {
                return Entity.userDefaultsValue
            }
            return result
        }
        set {
            userDefaults.set(newValue, forKey: Entity.userDefaultsKey)
        }
    }
}

extension UserPreference where Entity: RawRepresentable {
    var preference: Entity {
        get {
            guard let rawValue = userDefaults.object(forKey: Entity.userDefaultsKey) as? Entity.RawValue,
                let result = Entity(rawValue: rawValue) else {
                return Entity.userDefaultsValue
            }
            return result
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: Entity.userDefaultsKey)
        }
    }
    
}




