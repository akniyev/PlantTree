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
}

extension ApiTargets : TargetType {
    var baseURL: URL {
        return URL(string: "https://demo7991390.mockable.io")!
    }

    var path: String {
        switch self {
        case .registerWithEmail:
            return "/api/account/register/"
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerWithEmail:
            return .post
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
        default:
            return [:]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .registerWithEmail:
            return JSONEncoding.default // Send parameters in URL
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
        default:
            return "".utf8Encoded
        }
    }

    var task: Task {
        switch self {
        case .registerWithEmail:
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
