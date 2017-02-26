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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !url.isEmpty {
            webView.loadRequest(URLRequest(url: URL(string: url)!))
        }
    }
}
