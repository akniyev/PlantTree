//
//  GenderSelectorRow.swift
//  PlantTree
//
//  Created by Hasan on 15/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class GenderSelectorRow : Row<GenderSelectorCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        self.cellProvider = CellProvider<GenderSelectorCell>(nibName: "GenderSelectorCell")
    }
}
