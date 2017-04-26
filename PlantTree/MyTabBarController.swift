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
    let backgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        Db.CreateDbFile()
        ImageCache.default.maxDiskCacheSize = UInt(100 * 1024 * 1024)
        Server.GetProjectList(type: .active, page: 1, pagesize: 10, SUCCESS: nil, ERROR: nil)

        self.tabBar.isTranslucent = false

        let tb : UITabBar = self.tabBar
        tb.addSubview(self.backgroundView)
        let tabBackExtraHeight: CGFloat = 32
        self.backgroundView.frame = CGRect(x: -20, y: -tabBackExtraHeight, width: tb.bounds.width + 40, height: tb.bounds.height + tabBackExtraHeight)
        self.backgroundView.backgroundColor = UIColor.clear
        self.backgroundView.layer.shadowColor = UIColor.black.cgColor
        self.backgroundView.layer.shadowOpacity = 0.5
        self.backgroundView.layer.shadowOffset = CGSize.zero
        self.backgroundView.layer.shadowRadius = 7

        let tabDesiredHeight: CGFloat = 55
        let bb = backgroundView.bounds
        let ovalSize = CGSize(width: 80, height: 75)
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: bb.width / 2 - ovalSize.width / 2, y: bb.height / 2 - ovalSize.height / 2, width: ovalSize.width, height: ovalSize.height))
        let rectPath = UIBezierPath(rect: CGRect(x: 0, y: bb.height - tabDesiredHeight, width: bb.width, height: tabDesiredHeight))
        rectPath.append(ovalPath)
        let layerPath = rectPath
        let layerFill = CAShapeLayer()
        layerFill.fillColor = UIColor.white.cgColor
        layerFill.frame = self.backgroundView.layer.bounds
        layerFill.path = layerPath.cgPath

        //self.backgroundView.layer.backgroundColor = UIColor.clear.cgColor
        self.backgroundView.layer.addSublayer(layerFill)
//        self.backgroundView.layer.mask = layerFill
        //self.backgroundView.layer.shadowPath = layerPath.cgPath

//        let p = UIBezierPath()
//        p.moveToPoint(CGPointMake(20, 20))
//        p.addLineToPoint(CGPointMake(100, 20))
//        p.addLineToPoint(CGPointMake(100, 50))
//        p.addLineToPoint(CGPointMake(110, 55))
//        p.addLineToPoint(CGPointMake(100, 60))
//        p.addLineToPoint(CGPointMake(100, 100))
//        p.addLineToPoint(CGPointMake(20, 100))
//        p.closePath()
//
//        let s = CAShapeLayer()
//        s.fillColor = UIColor.whiteColor().CGColor
//        s.frame = layer.bounds
//        s.path = p.CGPath
//
//        layer.backgroundColor = UIColor.clearColor().CGColor
//        layer.addSublayer(s)
//
//        layer.masksToBounds = true
//        layer.shadowColor = UIColor.yellowColor().CGColor
//        layer.shadowOffset = CGSizeZero
//        layer.shadowOpacity = 0.9
//        layer.shadowPath = p.CGPath
//        layer.shadowRadius = 10




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
            v3.tabBarItem = ESTabBarItem(BigButtonContentView(), title: "", image: UIImage(named: "big_tree_button_inactive"), selectedImage: UIImage(named: "big_tree_button_active"), tag: 3)
            v4.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Завершенные", image: UIImage(named: "trees_inactive"), selectedImage: UIImage(named: "trees_active"), tag: 4)
            v5.tabBarItem = ESTabBarItem(SmallTabBarContentView(), title: "Профиль", image: UIImage(named: "profile_inactive"), selectedImage: UIImage(named: "profile_active"), tag: 5)
            
            self.selectedIndex = 2
        }
    }

}
