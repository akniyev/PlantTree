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

        self.tabBar.isTranslucent = false

        let vs = self.viewControllers
        if (vs != nil) && (vs?.count == 5) {
            let viewControllers = vs!
            let v1 = viewControllers[0]
            let v2 = viewControllers[1]
            let v3 = viewControllers[2]
            let v4 = viewControllers[3]
            let v5 = viewControllers[4]
            
            v1.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Инфо", image: UIImage(named: "info_inactive"), selectedImage: UIImage(named: "info_active"), tag: 1)
            v2.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Избранное", image: UIImage(named: "heart_inactive"), selectedImage: UIImage(named: "heart_active"), tag: 2)
            v3.tabBarItem = ESTabBarItem(BigButtonContentView(), title: "", image: UIImage(named: "tabbar-plant-tree-nonactive"), selectedImage: UIImage(named: "tabbar-plant-tree-active"), tag: 3)
            v4.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Завершенные", image: UIImage(named: "trees_inactive"), selectedImage: UIImage(named: "trees_active"), tag: 4)
            v5.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Профиль", image: UIImage(named: "profile_inactive"), selectedImage: UIImage(named: "profile_active"), tag: 5)
            
            self.selectedIndex = 2
        }
    }


    
}
