//
//  PlantTreeViewController.swift
//  PlantTree
//
//  Created by Admin on 27/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class PlantTreeViewController : FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section() <<< UpDownRow() { row in
            row.tag = "updown"
        } +++ Section() <<< ButtonRow() { row in
            row.title = "Посадить!"
        }
    }
}
