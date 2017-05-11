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

    // Manual
    static func SignInWithEmail_old(
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
    
    // Manual
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
    
    static func GetOperationHistory(page: Int, pagesize: Int, SUCCESS: (([OperationInfo]) -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            TransactionsAPI.apiTransactionsGet(page: Int32(page), pagesize: Int32(pagesize), authorization: "Bearer \(c.access_token)", completion: { ts, e in
                if let transactions = ts {
                    SUCCESS?(transactions.map({ $0.toOperationInfo() }))
                } else {
                    ERROR?(ErrorType.Unknown, "Не удаётся получить список операций!");
                    print(e?.localizedDescription)
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

    static func changePersonalData_old(image: UIImage?, first_name: String, second_name: String, gender: Gender, birth_date: Date,
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
    
    //Swagger
    static func UploadUserpic(image: UIImage?, SUCCESS: (() -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            if let img = image {
                let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
                let filepath = "\(paths[0])/my_temp_image.png"

                try! UIImagePNGRepresentation(img)?.write(to: URL(fileURLWithPath: filepath))
                AccountAPI.apiAccountPhotoPost(photo: URL(fileURLWithPath: filepath), authorization: "Bearer \(cred.access_token)", completion: { error in
                    if error == nil {
                        SUCCESS?()
                    } else {
                        print(error?.localizedDescription)
                        ERROR?(ErrorType.Unknown, "Не удаётся загрузить изображение!")
                    }
                    let fileManager = FileManager.default
                    try? fileManager.removeItem(atPath: filepath)
                })
            } else {
                ERROR?(ErrorType.InvalidData, "Неверный формат данных")
            }
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходима авторизация для загрузки изображения!")
        })
    }

    static func DeleteUserpic(SUCCESS: (() -> ())?, ERROR: ((ErrorType, String) -> ())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            AccountAPI.apiAccountPhotoDelete(authorization: "Bearer \(cred.access_token)", completion: { error in
                if error == nil {
                    SUCCESS?()
                } else {
                    ERROR?(ErrorType.Unknown, "При удалении фотографии произошла ошибка!")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходима авторизация для загрузки изображения!")
        })
    }

    static func changePersonalData(image: UIImage?, first_name: String, second_name: String, gender: Gender, birth_date: Date,
                                   SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            let userInfo = UserInfo()
            userInfo.birthday = birth_date.toRussianFormat()
            userInfo.name = first_name
            userInfo.lastName = second_name
            userInfo.gender = gender.toJsonCode()
            let rb = AccountAPI.apiAccountInfoPutWithRequestBuilder(info: userInfo, authorization: "Bearer \(cred.access_token)")
            rb.execute({ response, error in
                if error == nil {
                    SUCCESS?()
                } else {
                    ERROR?(ErrorType.Unknown, error!.localizedDescription)
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Требуется авторизация для выполнения данного запроса!")
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
    
    static func Like(projectId: Int, SUCCESS: (()->())?, ERROR: (()->())?) {
        MakeAuthorizedRequest(SUCCESS: { cred in
            ProjectsAPI.apiProjectsByIdLikePut(id: Int32(projectId), authorization: "Bearer \(cred.access_token)", completion: { error in
                if error == nil {
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
        MakeAuthorizedRequest(SUCCESS: { cred in
            ProjectsAPI.apiProjectsByIdDislikePut(id: Int32(projectId), authorization: "Bearer \(cred.access_token)", completion: { error in
                if error == nil {
                    SUCCESS?()
                } else {
                    ERROR?()
                    print(error!.localizedDescription)
                }
            })
        }, ERROR: { et, msg in
            ERROR?()
        }, UNAUTHORIZED: {
            ERROR?()
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
    
    static func changePassword(newPassword: String, oldPassword: String, SUCCESS: (()->())?, ERROR: ((ErrorType, String)->())?) {
        MakeAuthorizedRequest(SUCCESS: { c in
            let rb = AccountAPI.apiAccountPasswordByCurrentByNewpassPutWithRequestBuilder(current: oldPassword, newpass: newPassword)
            rb.addHeader(name: "Authorization", value: "Bearer \(c.access_token)")
            rb.execute({ response, error in
                if error == nil {
                    SUCCESS?()
                } else {
                    ERROR?(ErrorType.Unknown, error?.localizedDescription ?? "")
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            ERROR?(ErrorType.Unauthorized, "Необходимо авторизоваться для выполнения данного запроса!")
        })
    }
    
    static func SignInWithEmail(
        email: String,
        password: String,
        SUCCESS: ((Credentials) -> ())?,
        ERROR: ((ErrorType, String)->())?){

        let rb = ConnectAPI.apiConnectTokenPostWithRequestBuilder(
                username: email,
                password: password,
                grantType: "password",
                scope: "openid offline_access")
        rb.execute { at, e in
            if let error = e {
                ERROR?(ErrorType.ServerError, error.localizedDescription)
            } else if let access_token = at?.body?.accessToken,
                      let refresh_token = at?.body?.refreshToken,
                      let expire_in = at?.body?.expiresIn {
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
                ERROR?(ErrorType.Unknown, "Неизвестная ошибка!")
            }
        }
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
            switch type {
            case .active, .completed:
                let rb = ProjectsAPI.apiProjectsGetWithRequestBuilder(status: type.toCode(), page: Int32(page), pagesize: Int32(pagesize), authorization: "Bearer \(c.access_token)")
                rb.execute { projects, error in
                    if let prs = projects?.body {
                        SUCCESS?( prs.map { $0.toProjectInfo() })
                    } else {
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                }
            case .favorites:
                let rb = ProjectsAPI.apiProjectsUserGetWithRequestBuilder(page: Int32(page), pagesize: Int32(pagesize), authorization: "Bearer \(c.access_token)")
                rb.execute({ projects, error in
                    if let prs = projects?.body {
                        SUCCESS?(prs.map {$0.toProjectInfo()})
                    } else {
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                })
            }
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        }, UNAUTHORIZED: {
            switch type {
            case .active, .completed:
                let rb = ProjectsAPI.apiProjectsGetWithRequestBuilder(status: type.toCode(), page: Int32(page), pagesize: Int32(pagesize), authorization: "")
                rb.execute { projects, error in
                    if let prs = projects?.body {
                        SUCCESS?( prs.map { $0.toProjectInfo() })
                    } else {
                        ERROR?(ErrorType.ServerError, error?.localizedDescription ?? "")
                    }
                }
            case .favorites:
                ERROR?(ErrorType.Unauthorized, "Пользователь должен быть зарегистрирован")
            }
        })
    }
    
    static func GetProjectNews(projectId: Int, page: Int, pageSize: Int, SUCCESS: (([NewsPiece])->())?, ERROR: ((ErrorType, String) -> ())?) {
        let rb = NewsAPI.apiNewsGetWithRequestBuilder(projectId: Int32(projectId), page: Int32(page), pagesize: Int32(pageSize))
        rb.execute { news, error in
            if error != nil {
                ERROR?(ErrorType.Unknown, "Не удается получить данные")
            } else if let ns = news?.body {
                SUCCESS?(ns.map{$0.toNewsPiece()})
            } else {
                ERROR?(ErrorType.Unknown, "Полученые некорректные данные")
            }
        }
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
                    if let project = r?.body {
                        let projectInfo = project.toProjectInfo()
                        SUCCESS?(projectInfo)
                    } else {
                        ERROR?(ErrorType.ServerError, "Получены некорректные данные!")
                    }
                }
            })
        }, ERROR: { et, msg in
            ERROR?(et, msg)
        })
    }
    
    static func ResetPassword(email: String, ERROR: ((ErrorType, String) -> ())?, SUCCESS: (() -> ())?) {
        AccountAPI.apiAccountForgotByEmailPost(email: email, completion: { error in
            if error == nil {
                SUCCESS?()
            } else {
                ERROR?(ErrorType.Conflict, error?.localizedDescription ?? "Произошла ошибка при обработке вашего зарпоса")
            }
        })
    }

    static func GetNewsInfo(newsId: Int, SUCCESS: ((NewsPiece) -> ())?, ERROR: (() -> ())?) {
        let rb = NewsAPI.apiNewsByIdGetWithRequestBuilder(id: Int32(newsId))
        rb.execute { response in
            if let news = response.0?.body {
                SUCCESS?(news.toNewsPiece())
            } else {
                ERROR?()
            }
        }
    }
}
