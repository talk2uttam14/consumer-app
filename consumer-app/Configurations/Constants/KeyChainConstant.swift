//
//  KeyChainConstant.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 09/01/26.
//

import Foundation

public class KeyChainConstant {
    public static let authKey = "AUTHORIZATION"
    public static let userMobileKey = "MOBILENUMBER"
    public static let userLang = "USERLANG"
    public static let tenantIdKey = "TENANTID"
    public static let tenantNameKey = "TENANTNAME"
    public static let clubIdKey = "CLUBID"
    public static let clubNameKey = "CLUBNAME"
    public static let serviceKey = Bundle.main.bundleIdentifier ?? "com.comviva.boostmobile.BoostMobile"
}
