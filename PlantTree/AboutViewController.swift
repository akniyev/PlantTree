//
//  AboutViewController.swift
//  PlantTree
//
//  Created by Hasan on 09/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class AboutViewController : ReloadableViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "О приложении"
        
        reloadAction()
    }
    
    override func reloadAction() {
        self.webView.delegate = self
        let url = URL (string: "https://mitpress.mit.edu/sicp/full-text/book/book.html")
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj)
    }

    public func webViewDidStartLoad(_ webView: UIWebView) {
        LoadingIndicatorView.show()
        self.hideReloadView()
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingIndicatorView.hide()
        self.hideReloadView()
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LoadingIndicatorView.hide()
        self.showReloadView()
    }

}
