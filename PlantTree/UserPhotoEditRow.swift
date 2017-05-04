//
//  UserPhotoEditRow.swift
//  PlantTree
//
//  Created by Admin on 19/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

final class UserPhotoEditRow : Row<UserPhotoEditCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<UserPhotoEditCell>(nibName: "UserPhotoEditCell")
        self.baseCell.backgroundColor = UIColor.clear
    }
    
    func GetImage() -> UIImage? {
        if (cell as? UserPhotoEditCell)?.noPhoto == true {
            return nil
        } else {
            return (cell as? UserPhotoEditCell)?.imgPhoto.image
        }
    }
    
    var imageSelectAction : ((UserPhotoEditCell) -> ())?
    
    var imageDeleteAction : ((UserPhotoEditCell) -> ())?
}
