//
//  Server.swift
//  PlantTree
//
//  Created by Admin on 16/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import Alamofire

class Server {
    static let provider = MoyaProvider<ApiTargets>()

    static func test() {
        provider.request(.test, completion: { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let json = JSON(data: data)
                print(json)
            case .failure(_): break
            }

        })
    }
    
    static func RegisterWithEmail(
            email: String,
            password: String,
            personalData: PersonalData,
            SUCCESS: (() -> ())?,
            ERROR: ((ErrorType, String)->())?) {

        provider.request(.registerWithEmail(email: email, password: password, personalData: personalData)) { result in
            switch result {
            case let .success(moyaResponse):
                if moyaResponse.statusCode == 201 {
                    SUCCESS?()
                } else {
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    if json["error_title"].exists() && json["rus_description"].exists() {
                        ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                    } else {
                        ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                    }
                }
            case .failure(_):
                ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
            }
        }
    }

    static func SignInWithEmail(
            email: String,
            password: String,
            SUCCESS: ((Credentials) -> ())?,
            ERROR: ((ErrorType, String)->())?) {
        provider.request(.getTokenWithEmail(email: email, password: password), completion: { result in
            switch result {
            case let .success(moyaResponse):
                if moyaResponse.statusCode == 200 {
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    if json["access_token"].exists() && json["refresh_token"].exists() && json["expire_in"].exists() {
                        let access_token = json["access_token"].stringValue
                        let refresh_token = json["refresh_token"].stringValue
                        let expire_in = json["expire_in"].intValue
                        
                        let c = Credentials()
                        c.access_token = access_token
                        c.refresh_token = refresh_token
                        c.accessTokenExpireTime = Double(expire_in)
                        c.access_token_created = Date()
                        c.refresh_token_created = Date()
                        c.email = email
                        c.loginType = LoginType.Email
                        
                        if Db.writeCredentials(c: c) {
                            SUCCESS?(Credentials())
                        } else {
                            ERROR?(ErrorType.DatabaseError, "Ошибка записи в базу данных")
                        }
                    } else {
                        ERROR?(ErrorType.InvalidData, "Неправильный ответ от сервера")
                    }
                } else {
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    if json["error_title"].exists() && json["rus_description"].exists() {
                        ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                    } else {
                        ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                    }
                }
            case .failure(_):
                ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
            }
        })
    }

    static func MakeAuthorizedRequest(
            SUCCESS: ((Credentials)->())?,
            ERROR: ((ErrorType, String)->())?,
            UNAUTHORIZED: (()->())?) {
        if let c = Db.readCredentials() {
            //If user was authorized we should check if his tokes are expired or not
            if c.is_access_token_expired() {
                if c.is_refresh_token_expired() {
                    //If refresh token is expired we should sign out
                    UNAUTHORIZED?()
                    Server.SignOut()
                } else {
                    //Renew access token
                    Server.RenewAccessToken(SUCCESS: { rc in
                        SUCCESS?(rc)
                    }, ERROR: { et, msg in
                        if et == ErrorType.AuthorizationError {
                            UNAUTHORIZED?()
                            Server.SignOut()
                        } else {
                            ERROR?(et, msg)
                        }
                    })
                }
            } else {
                SUCCESS?(c)
            }
        } else {
            //If user is unauthorized, we call UNAUTHORIZED function
            UNAUTHORIZED?()
        }
    }
    
    static func MakeRequestWithOptionalAuthorization(SUCCESS: ((Credentials?)->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            SUCCESS?(c)
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            SUCCESS?(nil)
        })
    }

    static func GetProjectList(type : ProjectListType, page: Int, pagesize: Int, SUCCESS: (([ProjectInfo])->())?, ERROR: ((ErrorType, String)->())?) {
        MakeRequestWithOptionalAuthorization(SUCCESS: { c in
            let authorization = c == nil ? "GUEST" : "Bearer \(c!.access_token)"
            provider.request(.getProjectList(type: type, page: page, pagesize: pagesize, authorization: authorization),
                    completion: { result in
                        switch result {
                        case let .success(moyaResponse):
                            if moyaResponse.statusCode == 200 {
                                let data = moyaResponse.data
                                let json = JSON(data: data)
                                var projects : [ProjectInfo] = []
                                for (i, j) in json {
                                    var p : ProjectInfo = ProjectInfo()
                                    if (paramsInJson(json: j, params: ["id", "name", "description", "goal", "reached", "status", "mainImageUrlSmall", "likesCount", "isLikedByMe", "treePrice", "sponsorsCount"])) {
                                        let id = j["id"].intValue
                                        let name = j["name"].stringValue
                                        let description = j["description"].stringValue
                                        let goal = j["goal"].intValue
                                        let reached = j["reached"].intValue
                                        let status = ProjectStatus.fromString(s: json["status"].stringValue)
                                        let mainImageUrlSmall = j["mainImageUrlSmall"].stringValue
                                        let likeCount = j["likesCount"].intValue
                                        let isLikedByMe = j["isLikedByMe"].boolValue
                                        let treePrice = j["treePrice"].doubleValue
                                        let sponsorCount = j["sponsorsCount"].intValue
                                        p.id = id
                                        p.name = name
                                        p.description = description
                                        p.goal = goal
                                        p.reached = reached
                                        p.projectStatus = status
                                        p.mainImageUrlSmall = mainImageUrlSmall
                                        p.likeCount = likeCount
                                        p.isLikedByMe = isLikedByMe
                                        p.treePrice = treePrice
                                        p.sponsorCount = sponsorCount

                                        projects.append(p)
                                    } else {
                                        ERROR?(ErrorType.InvalidData, "Неправильный формат данных")
                                        return
                                    }
                                }
                                SUCCESS?(projects)
                            } else {
                                let data = moyaResponse.data
                                let json = JSON(data: data)
                                if json["error_title"].exists() && json["rus_description"].exists() {
                                    ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                                } else {
                                    ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                                }
                            }
                        case .failure(_):
                            ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
                        }
                    })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        })
    }
    
    static func GetProjectDetailInfo(projectId: Int, SUCCESS: ((ProjectInfo)->())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeRequestWithOptionalAuthorization(SUCCESS: { c in
            let authorization = c == nil ? "GUEST" : "Bearer \(c!.access_token)"
            provider.request(ApiTargets.getProjectDetailInfo(projectId: projectId, authorization: authorization), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
                        let data = moyaResponse.data
                        let json = JSON(data: data)
                        if paramsInJson(json: json, params: ["id", "name", "description", "goal", "reached", "status", "isLikedByMe", "treePrice", "sponsorCount", "creationDate", "allImagesBig"]) {
                            let p = ProjectInfo()
                            let id = json["id"].intValue
                            let name = json["name"].stringValue
                            let description = json["description"].stringValue
                            let goal = json["goal"].intValue
                            let reached = json["reached"].intValue
                            let status = ProjectStatus.fromString(s: json["status"].stringValue)
                            let allImagesBig : [String] = (json["allImagesBig"].arrayObject as? [String]) ?? []
                            let likeCount = json["likesCount"].intValue
                            let isLikedByMe = json["isLikedByMe"].boolValue
                            let treePrice = json["treePrice"].doubleValue
                            let sponsorCount = json["sponsorsCount"].intValue
                            let news = json["news"]
                            p.id = id
                            p.name = name
                            p.description = description
                            p.goal = goal
                            p.reached = reached
                            p.projectStatus = status
                            p.allImages = allImagesBig
                            p.likeCount = likeCount
                            p.isLikedByMe = isLikedByMe
                            p.treePrice = treePrice
                            p.sponsorCount = sponsorCount
                            p.news = []
                            for (_, newsJson) in news {
                                if paramsInJson(json: newsJson, params: ["id", "url", "title", "date", "imageUrl"]) {
                                    let np = NewsPiece()
                                    np.id = newsJson["id"].intValue
                                    np.title = newsJson["title"].stringValue
                                    np.date = Date.fromRussianFormat(s: newsJson["date"].stringValue)
                                    np.imageUrl = newsJson["imageUrl"].stringValue
                                    np.url = newsJson["url"].stringValue
                                    p.news.append(np)
                                }
                            }
                            SUCCESS?(p)
                        } else {
                            ERROR?(ErrorType.InvalidData, "Неправильный формат данных")
                            return
                        }
                    } else {
                        let data = moyaResponse.data
                        let json = JSON(data: data)
                        if json["error_title"].exists() && json["rus_description"].exists() {
                            ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                        } else {
                            ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                        }
                    }
                case .failure(_):
                    ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        })
    }
    
    static func GetOperationHistory(SUCCESS: (([OperationInfo]) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            provider.request(ApiTargets.getOperationHistory(access_token: c.access_token),
                             completion: { result in
                                switch result {
                                case let .success(moyaResponse):
                                    if moyaResponse.statusCode == 200 {
                                        let data = moyaResponse.data
                                        let json = JSON(data: data)
                                        var operations : [OperationInfo] = []
                                        for (_, j) in json {
                                            let o : OperationInfo = OperationInfo()
                                            if (paramsInJson(json: j, params: ["id", "projectTitle", "projectId", "date", "donated", "treePlanted", "cardLastDigits"])) {
                                                
                                                o.id = j["id"].intValue
                                                o.projectTitle = j["projectTitle"].stringValue
                                                o.projectId = j["projectId"].intValue
                                                o.date = Date.fromRussianFormat(s: j["date"].stringValue)!
                                                o.donated = j["donated"].doubleValue
                                                o.treePlanted = j["treePlanted"].intValue
                                                o.cardLastDigits = j["cardLastDigits"].stringValue
                                                
                                                operations.append(o)
                                            } else {
                                                ERROR?(ErrorType.InvalidData, "Неправильный формат данных")
                                                return
                                            }
                                        }
                                        SUCCESS?(operations)
                                    } else {
                                        let data = moyaResponse.data
                                        let json = JSON(data: data)
                                        if json["error_title"].exists() && json["rus_description"].exists() {
                                            ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                                        } else {
                                            ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                                        }
                                    }
                                case .failure(_):
                                    ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
                                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться!")
        })
    }

    static func RenewAccessToken(SUCCESS: ((Credentials) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        //Nullable credentials
        let cq = Db.readCredentials()

        //If cq nil than we are unauthorized
        if cq == nil {
            ERROR?(ErrorType.Unauthorized, "Unauthorized")
            return
        }
        let c = cq!

        provider.request(.refreshAccessToken(refresh_token: c.refresh_token), completion: { result in
            switch result {
            case let .success(moyaResponse):
                if moyaResponse.statusCode == 200 {
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    print(json)
                    if paramsInJson(json: json, params: ["access_token", "refresh_token", "expire_in"]) {
                        let access_token = json["access_token"].stringValue
                        let refresh_token = json["refresh_token"].stringValue
                        let expire_in = json["expire_in"].intValue

                        let c = Db.readCredentials() ?? Credentials()
                        c.access_token = access_token
                        c.refresh_token = refresh_token
                        c.accessTokenExpireTime = Double(expire_in)
                        c.access_token_created = Date()
                        c.refresh_token_created = Date()

                        if Db.writeCredentials(c: c) {
                            SUCCESS?(Credentials())
                        } else {
                            ERROR?(ErrorType.DatabaseError, "Ошибка записи в базу данных")
                        }
                    } else {
                        ERROR?(ErrorType.InvalidData, "Неправильный ответ от сервера")
                    }
                } else {
                    let data = moyaResponse.data
                    let json = JSON(data: data)
                    if json["error_title"].exists() && json["rus_description"].exists() {
                        ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                    } else {
                        ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                    }
                }
            case .failure(_):
                ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
            }
        })
    }

    static func GetAccountInfo(SUCCESS: ((PersonalData) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            provider.request(.getAccountInfo(access_token: c.access_token), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
                        let data = moyaResponse.data
                        let json = JSON(data: data)
                        print(json)
                        if paramsInJson(json: json, params: ["user_id", "photo", "photo_small", "first_name", "second_name",
                        "gender", "birthdate", "email", "email_confirmed", "login_type", "donated", "donatedProjectCount"]) {
                            let user_id = json["user_id"].intValue
                            let photo = json["photo"].stringValue
                            let photo_small = json["photo_small"].stringValue
                            let first_name = json["first_name"].stringValue
                            let second_name = json["second_name"].stringValue
                            let gender = Gender.fromJsonCode(code: json["gender"].stringValue)
                            let birthdate = Date.fromRussianFormat(s: json["birthdate"].stringValue)
                            let email = json["email"].stringValue
                            let email_confirmed = json["email_confirmed"].stringValue.lowercased() == "true"
                            let moneyDonated = json["donated"].intValue
                            let donatedProjectCount = json["donatedProjectCount"].intValue

                            let pd = PersonalData()
                            pd.email = email

                            pd.userid = user_id
                            pd.firstname = first_name
                            pd.secondname = second_name
                            pd.birthdate = birthdate
                            pd.gender = gender
                            pd.photoUrl = photo
                            pd.photoUrlSmall = photo_small
                            pd.moneyDonated = moneyDonated
                            pd.donatedProjectCount = donatedProjectCount
                            pd.email_confirmed = email_confirmed
                            

                            SUCCESS?(pd)
                        } else {
                            ERROR?(ErrorType.InvalidData, "Неправильный ответ от сервера")
                        }
                    } else {
                        let data = moyaResponse.data
                        let json = JSON(data: data)
                        if json["error_title"].exists() && json["rus_description"].exists() {
                            ERROR?(ErrorType.ServerError, json["rus_description"].stringValue)
                        } else {
                            ERROR?(ErrorType.ServerError, "Неизвестная ошибка сервера")
                        }
                    }
                case .failure(_):
                    ERROR?(ErrorType.NetworkError, "Не могу получить ответ от сервера")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться")
        })
    }

    static func SignOut() {
        Db.writeCredentials(c: nil)
    }

    static func Like(projectId: Int, SUCCESS: (()->())?, ERROR: (()->())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            provider.request(.like(id: projectId, a_token: cred.access_token), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
                        SUCCESS?()
                    } else {
                        ERROR?()
                    }
                case .failure(_):
                    ERROR?()
                }
            })
        }, ERROR: { et, msg in
            ERROR?()
        }, UNAUTHORIZED: {
            ERROR?()
        })
    }
    
    static func Unlike(projectId: Int, SUCCESS: (()->())?, ERROR: (()->())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            provider.request(.unlike(id: projectId, a_token: cred.access_token), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
                        SUCCESS?()
                    } else {
                        ERROR?()
                    }
                case .failure(_):
                    ERROR?()
                }
            })
        }, ERROR: { et, msg in
            ERROR?()
        }, UNAUTHORIZED: {
            ERROR?()
        })
    }

    static func paramsInJson(json: JSON, params: [String]) -> Bool {
        for param in params {
            if !json[param].exists() {
                return false
            }
        }
        return true
    }

    static func changePersonalData(access_token: String, image: UIImage?, first_name: String, second_name: String, gender: Gender, birth_date: Date,
                                   SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        Alamofire.upload(multipartFormData: { multipartData in
            if let img = image {
                multipartData.append(UIImageJPEGRepresentation(img, 0.9)!, withName: "userpic", mimeType: "image/jpeg")
            }
            multipartData.append(first_name.data(using: .utf8)!, withName: "first_name")
            multipartData.append(second_name.data(using: .utf8)!, withName: "second_name")
            multipartData.append(gender.toJsonCode().data(using: .utf8)!, withName: "gender")
            multipartData.append(birth_date.toRussianFormat().data(using: .utf8)!, withName: "birthdate")
        }, to: "\(ApiTargets.SERVER)/api/account/change_personal_data/", encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let d, _, _):
                if d.response?.statusCode == 200 {
                    SUCCESS?()
                } else {
                    ERROR?(ErrorType.)
                }
            case .failure(let error):
                ERROR?(ErrorType.NetworkError, "Не удается получить ответ от сервера")
            }
        })
    }

    static func changePassword() {

    }

    static func changeEmail() {

    }

    static func confirmEmail() {

    }
}
