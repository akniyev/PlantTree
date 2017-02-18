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

    static func fromRussianFormat(s : String) -> Date? {
        let segments = s.components(separatedBy: ".")
        if (segments.count == 3) {
            let s1 = segments[0]
            let s2 = segments[1]
            let s3 = segments[2]
            do {
                let d = Int(s1)
                let m = Int(s2)
                let y = Int(s3)

                var c = DateComponents()
                c.day = d
                c.month = m
                c.year = y

                return Calendar(identifier: .gregorian).date(from: c)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
