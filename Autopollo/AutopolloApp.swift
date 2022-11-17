//
//  AutopolloApp.swift
//  Autopollo
//
//  Created by Winston Hsieh on 2022/10/2.
//

import Foundation
import SwiftUI

struct DefaultsKeys {
    static let companyCode = "COMPANY_CODE"
    static let employeeNo  = "EMPLOYEE_NO"
    static let password    = "PASSWORD"
}

@main
struct AutopolloApp: App {
    let userDefaults = UserDefaults.standard
    
    var body: some Scene {
        WindowGroup {
            if userDefaults.string(forKey: DefaultsKeys.companyCode) == nil ||
                userDefaults.string(forKey: DefaultsKeys.employeeNo) == nil ||
                userDefaults.string(forKey: DefaultsKeys.password) == nil {
                FormView()
            } else {
                ContentView(url: "https://apollo.mayohr.com/ta?id=webpunch")
            }
        }
    }
}
