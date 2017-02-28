//
//  UpDownRow.swift
//  PlantTree
//
//  Created by Admin on 28/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class UpDownRow : Row<UpDownCellTableViewCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<UpDownCellTableViewCell>(nibName: "UpDownCellTableViewCell")
    }
}
