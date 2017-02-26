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
    case getProjectList(type : ProjectListType, page: Int, pagesize: Int, authorization: String)
    case like(id: Int, a_token: String)
    case unlike(id: Int, a_token: String)
    case getProjectDetailInfo(projectId: Int, authorization: String)
    case test
}

extension ApiTargets : TargetType {
    var baseURL: URL {
        switch self {
        case .test, .getProjectList, .like, .unlike, .getProjectDetailInfo:
            return URL(string: "http://localhost:8080")!
        default:
            return URL(string: "https://demo7991390.mockable.io")!
        }
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
        case .getProjectList(let type, let page, let pagesize, _):
            switch type {
            case .active: return "api/projects/active/list/page/\(page)/pagesize/\(pagesize)/"
            case .favorites: return "api/projects/favorites/list/page/\(page)/pagesize/\(pagesize)/"
            case .completed: return "api/projects/completed/list/page/\(page)/pagesize/\(pagesize)/"
            }
        case .like(let id, _):
            return "api/project/like/\(id)/"
        case .unlike(let id, _):
            return "api/project/unlike/\(id)/"
        case .getProjectDetailInfo(let id, _):
            return "api/project/details/\(id)/"
        case .test:
            return "/user/34"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .refreshAccessToken:
            return .post
        case .getAccountInfo, .getProjectList, .getProjectDetailInfo:
            return .get
        case .like, .unlike:
            return .put
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
            return ["refresh_token" : refresh_token]
        case .getProjectList( _, _, _, let authorization):
            return ["Authorization" : authorization]
        case .like(_, let a_token), .unlike(_, let a_token):
            return ["Authorization" : "Bearer \(a_token)"]
        case .getProjectDetailInfo(_, let authorization):
            return ["Authorization" : authorization]
        default:
            return [:]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .refreshAccessToken, .like, .unlike:
            return JSONEncoding.default // Send parameters in URL
        case .getAccountInfo, .getProjectList, .getProjectDetailInfo:
            return URLEncoding.default
        default:
            return URLEncoding.default // Send parameters as JSON in request body
        }
    }

    var sampleData: Data {
        switch self {
        case .registerWithEmail:
            return "".utf8Encoded
        case .getTokenWithEmail, .getAccountInfo, .refreshAccessToken, .getProjectList, .like, .unlike:
            return "".utf8Encoded
        default:
            return "".utf8Encoded
        }
    }

    var task: Task {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .getAccountInfo, .refreshAccessToken, .getProjectList, .like, .unlike, .getProjectDetailInfo:
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
