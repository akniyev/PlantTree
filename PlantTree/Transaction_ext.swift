//
// Created by Admin on 26/04/2017.
// Copyright (c) 2017 greenworld. All rights reserved.
//

import Foundation

extension Transaction {
    func toOperationInfo() -> OperationInfo {
        let t = self
        let oi = OperationInfo()

        oi.id = Int(t.id ?? -1)
        oi.projectId = Int(t.projectId ?? -1)
        oi.date = t.finishedDate ?? Date()
        oi.donated = t.amount ?? 0.0
        oi.projectTitle = t.projectTitle ?? ""
        oi.treePlanted = Int(t.treeCount ?? -1)
        oi.cardLastDigits = "0000"
        return oi
    }
}