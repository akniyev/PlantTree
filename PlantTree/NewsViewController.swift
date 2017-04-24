//
//  NewsViewController.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class NewsViewController : UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var url : String = ""
    var news : NewsPiece? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новость"

        if let np = news {

        }
    }
}
