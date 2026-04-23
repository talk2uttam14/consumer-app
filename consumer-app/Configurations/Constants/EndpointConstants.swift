//
//  EndpointConstants.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 13/01/26.
//


public enum EndpointConstants {

    public enum getEndpoints {
        public static let profile = "/user/profile"
        public static let accounts = "/accounts"
        public static let wallets = "/wallets"
        public static let transactions = "/transactions"
        public static let getLanguages = "mobiquitypay/faq/consumer/en"
    }

    public enum postEndpoints {
        public static let login = "/auth/login"
        public static let transfer = "/wallet/transfer"
        public static let updateProfile = "/user/update"
    }

    public enum putEndpoints {
        public static let updateSettings = "/settings"
    }
}
