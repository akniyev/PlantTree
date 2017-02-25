//
//  TableViewUnauthorized.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class TableViewUnauthorized : UIView {
    var authorizeAction : (() -> ())?
    @IBAction func authorizeTouched(_ sender: Any) {
        authorizeAction?()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
