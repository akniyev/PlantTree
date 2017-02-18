//
//  MyTabBarController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class MyTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Db.CreateDbFile()
    }
}
