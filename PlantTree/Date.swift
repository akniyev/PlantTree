//
// Created by Admin on 16/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

extension Date {
    func toRussianFormat() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return "\(String(format: "%02d", day)).\(String(format: "%02d", month)).\(year)"
    }
}