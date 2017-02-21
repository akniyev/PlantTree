//
//  MyTabBarController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Kingfisher

class MyTabBarController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Db.CreateDbFile()
        ImageCache.default.maxDiskCacheSize = UInt(100 * 1024 * 1024)
        Server.GetProjectList(type: .active, page: 1, pagesize: 10, SUCCESS: nil, ERROR: nil)
    }
}
