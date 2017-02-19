//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

enum Gender {
    case Male
    case Female
    case None

    func toJsonCode() -> String {
        switch self {
            case .Male:
                return "male"
            case .Female:
                return "female"
            default:
                return "none"
        }
    }

    static func fromJsonCode(code: String) -> Gender {
        if code.lowercased() == "male" {
            return Gender.Male
        } else if code.lowercased() == "female" {
            return Gender.Female
        } else {
            return Gender.None
        }
    }
    
    func toRussianFormat() -> String {
        switch self {
        case .Male:
            return "Мужской"
        case .Female:
            return "Женский"
        default:
            return "Не задан"
        }
    }
    
    static func fromRussianFormat(code: String) -> Gender {
        if code.lowercased() == "мужской" {
            return Gender.Male
        } else if code.lowercased() == "женский" {
            return Gender.Female
        } else {
            return Gender.None
        }
    }
}
