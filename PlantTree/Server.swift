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
    static func RegisterWithEmail(
            email: String,
            password: String,
            personalData: PersonalData,
            SUCCESS: (() -> ())?,
            ERROR: ((ErrorType, String)->())?) {
        let provider = MoyaProvider<ApiTargets>()
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

    static func MakeAuthorizedOrGuestRequest(
            SUCCESS: ((Credentials)->())?,
            ERROR: (()->())?) {

    }

    static func MakeAuthorizedRequest(
            SUCCESS: ((Credentials)->())?,
            ERROR: ((ErrorType, String)->())?,
            UNAUTHORIZED: (()->())?) {

    }
}
