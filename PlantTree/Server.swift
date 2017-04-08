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
    static let provider = MoyaProvider<ApiTargets>(endpointClosure: { (target: ApiTargets) -> Endpoint<ApiTargets> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        switch target {
        case .getTokenWithEmail:
            return defaultEndpoint.adding(newHTTPHeaderFields: ["Content-Type": "application/x-www-form-urlencoded"])
        default:
            return defaultEndpoint
        }
    })

    static func SignInWithEmail(
        email: String,
        password: String,
        SUCCESS: ((Credentials) -> ())?,
        ERROR: ((ErrorType, String)->())?) {
        
        let parameters : Parameters = [
            "username" : email,
            "grant_type" : "password",
            "scope" : "openid offline_access",
            "password" : password
        ]
        let headers : HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let data = Alamofire.request(
            "http://rasuldev-001-site28.btempurl.com/api/connect/token",
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers).validate(statusCode: 200..<201)
        data.responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["access_token"].exists() && json["refresh_token"].exists() {
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
                        SUCCESS?(c)
                    } else {
                        ERROR?(ErrorType.DatabaseError, "Ошибка записи в базу данных")
                    }
                } else {
                    ERROR?(ErrorType.InvalidData, "Получены неверные данные!")
                }
            case .failure(_):
                if response.response?.statusCode == 400 {
                    ERROR?(ErrorType.InvalidCredentials, "Проверьте правильность ввода данных!")
                } else {
                    ERROR?(ErrorType.NetworkError, "Сервер недоступен!")
                }
            }
        })
    }
    
    static func SignInWithEmail_old(
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
        
        let parameters : Parameters = [
            "refresh_token" : c.refresh_token,
            "scope" : "openid offline_access",
            "grant_type" : "refresh_token"
        ]
        let headers : HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        //print(c.refresh_token)
        let data = Alamofire.request(
            "http://rasuldev-001-site28.btempurl.com/api/connect/token",
            method: .post,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers)//.validate(statusCode: 200..<201)
        data.responseJSON(completionHandler: {
            response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["access_token"].exists() && json["refresh_token"].exists() {
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
                    ERROR?(ErrorType.InvalidData, "Получены неверные данные!")
                }
            case .failure(_):
                if response.response?.statusCode == 400 {
                    ERROR?(ErrorType.InvalidCredentials, "Проверьте правильность ввода данных!")
                } else {
                    ERROR?(ErrorType.NetworkError, "Сервер недоступен!")
                }
            }
        })
    }

    static func GetAccountInfo_old(SUCCESS: ((PersonalData) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
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

    static func GetAccountInfo(SUCCESS: ((PersonalData) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            let rb = AccountAPI.apiAccountInfoGetWithRequestBuilder()
            rb.addHeader(name: "Authorization", value: "Bearer \(cred.access_token)")
            rb.execute({ r, e in
                if let userInfo = r?.body {
                    SUCCESS?(userInfo.toPersonalData())
                } else {
                    ERROR?(ErrorType.InvalidData, "Некорректный ответ сервера!")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться!")
        })
    }
    
    static func SignOut() {
        Db.writeCredentials(c: nil)
    }

    static func paramsInJson(json: JSON, params: [String]) -> Bool {
        for param in params {
            if !json[param].exists() {
                return false
            }
        }
        return true
    }

    static func changePersonalData(image: UIImage?, first_name: String, second_name: String, gender: Gender, birth_date: Date,
                                   SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            let headers: HTTPHeaders = [ "Authorization": "Bearer \(c.access_token)" ]
            let urlRequest = try! URLRequest(url: "\(ApiTargets.SERVER)/api/account/change_personal_data/", method: .post, headers: headers)
            
            print(urlRequest)
            
            Alamofire.upload(multipartFormData: { multipartData in
                if let img = image {
                    multipartData.append(UIImageJPEGRepresentation(img, 0.9)!, withName: "userpic", mimeType: "image/jpeg")
                }
                multipartData.append(first_name.data(using: .utf8)!, withName: "first_name")
                multipartData.append(second_name.data(using: .utf8)!, withName: "second_name")
                multipartData.append(gender.toJsonCode().data(using: .utf8)!, withName: "gender")
                multipartData.append(birth_date.toRussianFormat().data(using: .utf8)!, withName: "birthdate")
            }, with: urlRequest, encodingCompletion: { encodingResult in
                switch encodingResult {
                    //TODO: Manage to work with multipart data with our mock and real servers!!!
                case .success(let d, _, _):
                    if d.response?.statusCode == 200 {
                        SUCCESS?()
                    } else {
                        ERROR?(ErrorType.InvalidData, "Некорректный ответ от сервера")
                    }
                case .failure:
                    ERROR?(ErrorType.NetworkError, "Не удается получить ответ от сервера")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }

    static func changePassword(newPassword: String, oldPassword: String, SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            provider.request(.changePassword(access_token: c.access_token, old_password: oldPassword, new_password: newPassword), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
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
                    ERROR?(ErrorType.NetworkError, "Не получен ответ от сервера!")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }

    static func changeEmail(newEmail: String, SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            provider.request(.changeEmail(access_token: c.access_token, new_email: newEmail), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
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
                    ERROR?(ErrorType.NetworkError, "Не получен ответ от сервера!")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }

    static func confirmEmail(SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            let rb = AccountAPI.apiAccountConfirmPostWithRequestBuilder()
            rb.addHeader(name: "Authorization", value: "Bearer \(cred.access_token)")
            rb.execute{ response, error in
                if error == nil {
                    SUCCESS?()
                } else {
                    ERROR?(ErrorType.Unknown, error?.localizedDescription ?? "")
                }
            }
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized,  "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }
    
    static func confirmEmail_old(SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            provider.request(.confirm_email(access_token: c.access_token), completion: { result in
                switch result {
                case let .success(moyaResponse):
                    if moyaResponse.statusCode == 200 {
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
                    ERROR?(ErrorType.NetworkError, "Не получен ответ от сервера!")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }
    
    //Swagger
    
    static func Like(projectId: Int, SUCCESS: (()->())?, ERROR: (()->())?) {
        print("projectId: \(projectId)")
        MakeAuthorizedRequest(SUCCESS: { cred in
            let rb = ProjectsAPI.apiProjectsByIdLikePutWithRequestBuilder(id: Int32(projectId))
            rb.addHeader(name: "Authorization", value: "Bearer \(cred.access_token)")
            rb.execute({ r, e in
                if e == nil {
                    SUCCESS?()
                } else {
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
        print("projectId: \(projectId)")
        MakeAuthorizedRequest(SUCCESS: { cred in
            let rb = ProjectsAPI.apiProjectsByIdDislikePutWithRequestBuilder(id: Int32(projectId))
            rb.addHeader(name: "Authorization", value: "Bearer \(cred.access_token)")
            rb.execute({ r, e in
                if e == nil {
                    SUCCESS?()
                } else {
                    ERROR?()
                }
            })
        }, ERROR: { et, msg in
            ERROR?()
        }, UNAUTHORIZED: {
            ERROR?()
        })
    }

    
    static func SignInWithEmail_new(
        email: String,
        password: String,
        SUCCESS: ((Credentials) -> ())?,
        ERROR: ((ErrorType, String)->())?){
        ConnectAPI.apiConnectTokenPost(username: email, password: password, grantType: "password", scope: "openid offline_access", completion: { at, e in
            print(at?.accessToken ?? "")
            print(at?.refreshToken ?? "")
            print(e?.localizedDescription ?? "")
        })
    }
    
    // TODO: Make better error handling and error message display
    static func RegisterWithEmail(
        email: String,
        password: String,
        SUCCESS: (() -> ())?,
        ERROR: ((ErrorType, String)->())?) {
        
        let rm = RegisterModel()
        rm.email = email
        rm.password = password
        AccountAPI.apiAccountRegisterPost(registerInfo: rm, completion: { err in
            if let error = err {
                ERROR?(ErrorType.Unknown, error.localizedDescription)
            } else {
                SUCCESS?()
            }
        })
    }
    
    // TODO: Make authorized request for favorites (user projects)
    static func GetProjectList(type : ProjectListType, page: Int, pagesize: Int, SUCCESS: (([ProjectInfo])->())?, ERROR: ((ErrorType, String)->())?) {
        
        MakeAuthorizedRequest(SUCCESS: { c in
            if type != .favorites {
                let rb = ProjectsAPI.apiProjectsGetWithRequestBuilder(page: Int32(page), pagesize: Int32(pagesize))
                rb.addHeader(name: "Authorization", value: "Bearer \(c.access_token)")
                rb.execute({ projects, error in
                    if let prs = projects?.body {
                        SUCCESS?(prs.map {$0.toProjectInfo()})
                    } else {
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                })
            } else {
                let rb = ProjectsAPI.apiProjectsUserGetWithRequestBuilder(page: Int32(page), pagesize: Int32(pagesize))
                rb.addHeader(name: "Authorization", value: "Bearer \(c.access_token)")
                rb.execute({ projects, error in
                    if let prs = projects?.body {
                        SUCCESS?(prs.map {$0.toProjectInfo()})
                    } else {
                        print(error?.localizedDescription ?? "")
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                })
            }
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            switch type {
            case .active, .completed:
                ProjectsAPI.apiProjectsGet(status: type.toCode(), page: Int32(page), pagesize: Int32(pagesize), completion: { projects, error in
                    if let prs = projects {
                        SUCCESS?(prs.map {$0.toProjectInfo()})
                    } else {
                        print(error?.localizedDescription)
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                })
            case .favorites:
                ERROR?(ErrorType.Unauthorized, "Пользователь должен быть зарегистрирован")
            }
        })
    }
    
    static func GetProjectDetailInfo(projectId: Int, SUCCESS: ((ProjectInfo)->())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeRequestWithOptionalAuthorization(SUCCESS: { c in
            let rb = ProjectsAPI.apiProjectsByIdGetWithRequestBuilder(id: Int32(projectId))
            if let cred = c {
                rb.addHeader(name: "Authorization", value: "Bearer \(cred.access_token)")
            }
            rb.execute({ r, e in
                if let error = e {
                    ERROR?(ErrorType.Unknown, error.localizedDescription)
                } else {
                    SUCCESS?(r?.body?.toProjectInfo() ?? ProjectInfo())
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        })
    }
    
    static func ResetPassword(email: String, ERROR: (() -> ())?, SUCCESS: (() -> ())?) {
        AccountAPI.apiAccountForgotByEmailPost(email: email, completion: { error in
            if error == nil {
                SUCCESS?()
            } else {
                ERROR?()
            }
        })
    }
}
