//
//  MyTabBarController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Kingfisher
import ESTabBarController_swift

class MyTabBarController : ESTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Db.CreateDbFile()
        ImageCache.default.maxDiskCacheSize = UInt(100 * 1024 * 1024)
        Server.GetProjectList(type: .active, page: 1, pagesize: 10, SUCCESS: nil, ERROR: nil)
        
//        self.shouldHijackHandler = { tabbar, viewcontroller, index in
//            
//        }
        
        let vs = self.viewControllers
        if (vs != nil) && (vs?.count == 4) {
            let viewControllers = vs!
            let v1 = viewControllers[0]
            let v2 = viewControllers[1]
            let v3 = viewControllers[2]
            let v4 = viewControllers[3]
            
            v1.tabBarItem = ESTabBarItem(BigButtonContentView(), title: "Активные", image: UIImage(named: "LikeActive"), selectedImage: UIImage(named: "LikeInactive"), tag: 1)
        }
    }
    
    
}
