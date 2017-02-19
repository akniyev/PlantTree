//
//  UserInfoRow.swift
//  PlantTree
//
//  Created by Admin on 19/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class UserInfoRow : Row<UserInfoCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<UserInfoCell>(nibName: "UserInfoCell")
    }
}
