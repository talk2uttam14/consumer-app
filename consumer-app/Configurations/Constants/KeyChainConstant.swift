//
//  KeyChainConstant.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 09/01/26.
//

import Foundation

class KeyChainConstant {
    static let authKey = "AUTHORIZATION"
    static let userMobileKey = "MOBILENUMBER"
    static let userLang = "USERLANG"
    static let tenantIdKey = "TENANTID"
    static let tenantNameKey = "TENANTNAME"
    static let clubIdKey = "CLUBID"
    static let clubNameKey = "CLUBNAME"
    static let serviceKey = Bundle.main.bundleIdentifier ?? "com.comviva.boostmobile.BoostMobile"
}
