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

class Server {
    static let provider = MoyaProvider<ApiTargets>()

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
                        if paramsInJson(json: json, params: ["photo", "photo_small", "first_name", "second_name",
                        "gender", "birthdate", "email", "email_confirmed", "login_type", "donated", "donatedProjectCount"]) {
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

    static func paramsInJson(json: JSON, params: [String]) -> Bool {
        for param in params {
            if !json[param].exists() {
                return false
            }
        }
        return true
    }
}
