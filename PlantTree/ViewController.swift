//
//  ViewController.swift
//  PlantTree
//
//  Created by Admin on 15/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class ViewController: UIViewController {
    @IBAction func btn(_ sender: Any) {
//        let f = lbl.bounds
//        let s = lbl.sizeThatFits(CGSize(width: 200, height: 100000))
//        lbl.frame.size = CGSize(width: 200, height: s.height)
//        print(s)
//        lbl.frame.width = 200
        lbl.sizeToFit()
    }
    @IBAction func btnCopy(_ sender: Any) {
        lbl.text = text.text
    }
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var lbl: UILabel!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class Entity: Object {
    dynamic var name = ""
}

