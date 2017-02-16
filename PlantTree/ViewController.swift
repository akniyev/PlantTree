//
//  ViewController.swift
//  PlantTree
//
//  Created by Admin on 15/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        var entities: Results<Entity> = {
//            self.realm.objects(Entity)
//        }()
//        
//        print(entities)
//        
//        try! realm.write {
//            var e = Entity()
//            e.name = "HJK"
//            self.realm.add(e)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Entity: Object {
    dynamic var name = ""
}

