//
//  Language.swift
//  RescueApp
//
//  Created by Vasily Ptitsyn on 05/10/2018.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import Foundation

enum Language: String {
    case english
    case malayalam
}

extension Language: UserDefaultable {
    static var userDefaultsValue: Language = .english
    static var userDefaultsKey: String = "Language.defaultLanguage"
}
