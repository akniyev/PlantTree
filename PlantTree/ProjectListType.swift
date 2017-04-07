//
// Created by Admin on 20/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

enum ProjectListType {
    case active
    case favorites
    case completed
    
    static func fromCode(code: String) -> ProjectListType {
        switch code {
        case "active" : return .active
        case "favorites" : return .favorites
        case "completed" : return .completed
        default: return .active
        }
    }
    
    func toCode() -> String {
        switch self {
        case .active: return "active"
        case .completed: return "completed"
        case .favorites: return "favorites"
        }
    }
}
