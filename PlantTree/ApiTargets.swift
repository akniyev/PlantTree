//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum ApiTargets {
    static let SERVER : String = "http://rasuldev-001-site28.btempurl.com"

    case registerWithEmail(email: String, password: String, personalData: PersonalData)
    case getTokenWithEmail(email: String, password: String)
    case getAccountInfo(access_token: String)
    case refreshAccessToken(refresh_token: String)
    case getProjectList(type : ProjectListType, page: Int, pagesize: Int, authorization: String)
    case like(id: Int, a_token: String)
    case unlike(id: Int, a_token: String)
    case getProjectDetailInfo(projectId: Int, authorization: String)
    case getOperationHistory(access_token : String)
    case changeEmail(access_token: String, new_email: String)
    case changePassword(access_token: String, old_password: String, new_password: String)
    case changePersonalData(access_token: String, image: UIImage?, first_name: String, second_name: String, gender: Gender, birth_date: Date)
    case confirm_email(access_token: String)
    case reset_password(email: String)
}

extension ApiTargets : TargetType {
    var baseURL: URL {
        return URL(string: ApiTargets.SERVER)!
    }
    
    var path: String {
        switch self {
        case .registerWithEmail:
            return "/api/account/register/"
        case .getTokenWithEmail:
            return "api/connect/token"
        case .getAccountInfo:
            return "api/account/get_info/"
        case .refreshAccessToken:
            return "api/account/token/"
        case .getProjectList(let type, let page, let pagesize, _):
            switch type {
            case .active: return "api/projects/status/active/page/\(page)/pagesize/\(pagesize)"
            case .favorites: return "api/projects/user/page/\(page)/pagesize/\(pagesize)"
            case .completed: return "api/projects/status/finished/page/\(page)/pagesize/\(pagesize)"
            }
        case .like(let id, _):
            return "api/project/like/\(id)/"
        case .unlike(let id, _):
            return "api/project/unlike/\(id)/"
        case .getProjectDetailInfo(let id, _):
            return "api/projects/\(id)"
        case .getOperationHistory:
            return "api/account/operations/"
        case .changeEmail:
            return "api/account/email/change/"
        case .changePassword:
            return "api/account/password/change/"
        case .changePersonalData:
            return "api/account/change_personal_data/"
        case .confirm_email:
            return "api/account/email/confirm/"
        case .reset_password:
            return "api/account/password/reset/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .refreshAccessToken, .reset_password, .confirm_email, .changePersonalData:
            return .post
        case .getAccountInfo, .getProjectList, .getProjectDetailInfo, .getOperationHistory:
            return .get
        case .like, .unlike, .changeEmail, .changePassword:
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
                "email" : email,
                "password" : password,
                "grant_type" : "password",
                "scope" : "openid offline_access"
            ]
        case .getAccountInfo(let access_token), .getOperationHistory(let access_token):
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
        case .changeEmail(let access_token, _):
            return ["Authorization" : "Bearer \(access_token)"]
        case .changePassword(let access_token, _, _):
            return ["Authorization" : "Bearer \(access_token)"]
        case .changePersonalData(let access_token, _, _, _, _, _):
            return ["Authorization" : "Bearer \(access_token)"]
        case .confirm_email(let access_token):
            return ["Authorization" : "Bearer \(access_token)"]
        case .reset_password(let email):
            return [:]
        default:
            return [:]
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .registerWithEmail, .refreshAccessToken, .like, .unlike, .changeEmail, .changePassword, .changePersonalData, .confirm_email, .reset_password:
            return JSONEncoding.default // Send parameters in URL
        case .getAccountInfo, .getProjectList, .getProjectDetailInfo, .getOperationHistory, .getTokenWithEmail:
            return URLEncoding.default
        default:
            return URLEncoding.default // Send parameters as JSON in request body
        }
    }

    var sampleData: Data {
        switch self {
        case .registerWithEmail:
            return "".utf8Encoded
        case .getTokenWithEmail, .getAccountInfo, .refreshAccessToken, .getProjectList, .like, .unlike, .getOperationHistory:
            return "".utf8Encoded

        case .changeEmail(_, let new_email):
            var json : JSON = ["new_email" : new_email]
            let jsonString : String = json.rawString() ?? ""
            return jsonString.utf8Encoded
        case .changePassword(_, let old_password, let new_password):
            let json : JSON = ["old_password" : old_password, "new_password" : new_password]
            let jsonString : String = json.rawString() ?? ""
            return jsonString.utf8Encoded
        case .changePersonalData:
            //TODO: make multipart form data
            return "".utf8Encoded
        case .confirm_email:
            return "".utf8Encoded
        case .reset_password(let email):
            var json : JSON = ["email" : email]
            let jsonString : String = json.rawString() ?? ""
            return jsonString.utf8Encoded
        default:
            return "".utf8Encoded
        }
    }

    var task: Task {
        switch self {
        case .registerWithEmail, .getTokenWithEmail, .getAccountInfo, .refreshAccessToken, .getProjectList, .like, .unlike, .getProjectDetailInfo, .getOperationHistory, .changeEmail, .changePassword, .changePersonalData, .confirm_email, .reset_password:
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
