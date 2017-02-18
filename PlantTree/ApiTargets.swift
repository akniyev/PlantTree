//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum ApiTargets {
    case registerWithEmail(email: String, password: String, personalData: PersonalData)
    case getTokenWithEmail(email: String, password: String)
    case getAccountInfo(access_token: String)
    case refreshAccessToken(refresh_token: String)
}

extension ApiTargets : TargetType {
    var baseURL: URL {
        return URL(string: "https://demo7991390.mockable.io")!
    }

    var path: String {
        switch self {
        case .registerWithEmail:
            return "/api/account/register/"
        case .getTokenWithEmail:
            return "api/account/signin/"
        case .getAccountInfo:
            return "api/account/get_info/"
        case .refreshAccessToken:
            return "api/account/token/"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .refreshAccessToken:
            return .post
        case .getAccountInfo:
            return .get
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .registerWithEmail(let email, let password, let personalData):
            return [
                    "email": email,
                    "password": password,
                    "firstname": personalData.firstname,
                    "secondname": personalData.secondname,
                    "gender": personalData.gender.toJsonCode(),
                    "birthdate": (personalData.birthdate?.toRussianFormat() ?? "")
            ]
        case .getTokenWithEmail(let email, let password):
            return [
                "login_type" : "email",
                "email" : email,
                "password" : password
            ]
        case .getAccountInfo(let access_token):
            return [
                "Authorization" : "Bearer \(access_token)"
            ]
        case .refreshAccessToken(let refresh_token):
            return [
                "refresh_token" : refresh_token
            ]
        default:
            return [:]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .refreshAccessToken:
            return JSONEncoding.default // Send parameters in URL
        case .getAccountInfo:
            return URLEncoding.default
        default:
            return URLEncoding.default // Send parameters as JSON in request body
        }
    }

    var sampleData: Data {
        switch self {
        case .registerWithEmail(let email, let password, let personalData):
            let dict = [:] as [String: Any?]
            let json = JSON(dict)
            let representation = json.rawString([.castNilToNSNull: true]) ?? ""
            return representation.utf8Encoded
        case .getTokenWithEmail, .getAccountInfo, .refreshAccessToken:
            return "".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }

    var task: Task {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .getAccountInfo, .refreshAccessToken:
            return .request
        default:
            return .request
        }
    }
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
