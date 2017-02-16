//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

class Credentials {
    //Expire time for each token in seconds
    static let accessTokenExpireTime : Double = 1000
    static let refreshTokenExpireTime : Double = (14 * 60) * 3600
    static let socialTokenExpireTime : Double = (24 * 60) * 3600

    var email = ""
    var access_token = ""
    var access_token_created = Date()
    var refresh_token = ""
    var refresh_token_created = Date()
    var social_token = ""
    var loginType : LoginType = .Email

    func get_access_token_created_unixtime() -> Double {
        return access_token_created.timeIntervalSince1970
    }

    func get_refresh_token_created_unixtime() -> Double {
        return refresh_token_created.timeIntervalSince1970
    }

    func current_unixtime() -> Double {
        return Date().timeIntervalSince1970
    }

    func is_access_token_expired() -> Bool {
//        print("CURRENT UNIXTIME: \(current_unixtime())")
//        print("CURRENT TIME: \(Date())")
//        print(access_token_created)
//        print("EXPIRATION: \(current_unixtime() - get_access_token_created_unixtime())")
        return (current_unixtime() - get_access_token_created_unixtime()) > (Credentials.accessTokenExpireTime * 0.9)
    }

    func is_refresh_token_expired() -> Bool {
        return (current_unixtime() - get_refresh_token_created_unixtime()) > (Credentials.refreshTokenExpireTime * 0.99)
    }

    func set_refresh_token_created_from_unixtime(unixtime: Double) {
        refresh_token_created = Date(timeIntervalSince1970: unixtime)
    }

    func set_access_token_created_from_unixtime(unixtime: Double) {
        access_token_created = Date(timeIntervalSince1970: unixtime)
    }
}

enum LoginType {
    case None
    case Email
    case Facebook

    func toString() -> String {
        return "\(self)"
    }

    static func fromString(s : String) -> LoginType {
        switch s.lowercased() {
        case "email": return LoginType.Email
        case "facebook" : return LoginType.Facebook
        default: return LoginType.None
        }
    }
}