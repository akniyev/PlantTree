//
// Created by Admin on 23/02/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

extension Int {
    func withRussianCountWord(one: String, tofour: String, overfour: String) -> String {
        let lastDigit = abs(self) % 10
        let n = abs(self) % 100
        if n >= 11 && n <= 19 {
            return "\(self) \(overfour)"
        } else if lastDigit ==  1 {
            return "\(self) \(one)"
        } else if (lastDigit <= 4 && lastDigit != 0) {
            return "\(self) \(tofour)"
        } else {
            return "\(self) \(overfour)"
        }
    }

    func getRussianCountWord(one: String, tofour: String, overfour: String) -> String {
        let lastDigit = abs(self) % 10
        let n = abs(self) % 100
        if n >= 11 && n <= 19 {
            return overfour
        } else if lastDigit ==  1 {
            return one
        } else if (lastDigit <= 4 && lastDigit != 0) {
            return tofour
        } else {
            return overfour
        }
    }
    
    func toShortenString() -> String {
        let n = abs(self)
        let sign = self < 0 ? "-" : ""
        
        if n < 1000 {
            return "\(sign)\(n)"
        } else if n < 1_000_000 {
            let v = Double(n) / 1000.0
            return "\(sign)\(String(format: v == floor(v) ? "%.0f" : "%.1f", v))k"
        } else {
            let v = Double(n) / 1000000.0
            return "\(sign)\(String(format: v == floor(v) ? "%.0f" : "%.1f", v))M"
        }
    }
}
