//
//  UserPreferenceTest.swift
//  RescueAppTests
//
//  Created by Vasily Ptitsyn on 05/10/2018.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

import XCTest
@testable import RescueApp


class UserPreferenceTest: XCTestCase {
    private var userDefaults: UserDefaults!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }


    func testLanguage() {
        let userPreference = UserPreference<Language>(userDefaults: self.userDefaults)
        XCTAssertEqual(userPreference.preference, Language.userDefaultsValue)
        userPreference.preference = .malayalam
        XCTAssertEqual(userPreference.preference, Language.malayalam)
        userPreference.preference = .english
        XCTAssertEqual(userPreference.preference, Language.english)
    }
    

}
