//
//  GenderSelectorCell.swift
//  PlantTree
//
//  Created by Hasan on 15/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class GenderSelectorCell: Cell<Gender>, CellType {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setup() {
        super.setup()
        self.height = { return 60 }
    }
}
