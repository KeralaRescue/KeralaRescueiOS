//
//  UserDefaultable.swift
//  RescueApp
//
//  Created by Vasily Ptitsyn on 05/10/2018.
//  Copyright © 2018 Jayahari Vavachan. All rights reserved.
//

protocol UserDefaultable {
    static var userDefaultsValue: Self { get }
    static var userDefaultsKey: String { get }
}
