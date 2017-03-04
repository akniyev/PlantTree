//
// Created by Admin on 20/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

enum ProjectStatus {
    case none
    case active
    case collected
    case finished

    static func fromString(s : String) -> ProjectStatus {
        switch s.lowercased() {
        case "active":
            return .active
        case "reached":
            return .collected
        case "completed":
            return .finished
        default:
            return .none
        }
    }
}
