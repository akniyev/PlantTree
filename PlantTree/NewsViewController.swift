//
//  NewsViewController.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class NewsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var newsId: Int = -1
    var newsPiece: NewsPiece? = nil
    
    @IBOutlet weak var tv_NewsDetails: UITableView!
    var reloadView : ReloadView? = nil

    func showReloadView() {
        if let v = getReloadView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }

    func hideReloadView() {
        if let v = reloadView {
            v.removeFromSuperview()
        }
    }

    func getReloadView() -> ReloadView? {
        if let reloadView = Bundle.main.loadNibNamed("ReloadView", owner: self, options: nil)?.first as? ReloadView {
            self.reloadView = reloadView
            self.reloadView?.reloadAction = {
                self.refreshPage()
            }
        } else {
            self.reloadView = nil
        }
        return self.reloadView
    }

    func refreshPage() {
        hideReloadView()
        if self.newsId != -1 {
            LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
            Server.GetNewsInfo(newsId: self.newsId, SUCCESS: { np in
                self.newsPiece = np
                self.tv_NewsDetails.reloadData()
                LoadingIndicatorView.hide()
            }, ERROR: {
                LoadingIndicatorView.hide()
                self.showReloadView()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Новость"

        self.tv_NewsDetails.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellReuseIdentifier: "NewsHeaderCell")
        self.tv_NewsDetails.register(UINib(nibName: "NewsBodyCell", bundle: nil), forCellReuseIdentifier: "NewsBodyCell")
        self.tv_NewsDetails.register(UINib(nibName: "NewsFooterCell", bundle: nil), forCellReuseIdentifier: "NewsFooterCell")
        self.tv_NewsDetails.separatorStyle = .none
        self.tv_NewsDetails.allowsSelection = false
        self.tv_NewsDetails.dataSource = self
        self.tv_NewsDetails.delegate = self

        self.refreshPage()
    }

    // Table view delegate / data source
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.newsPiece == nil ? 0 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsPiece == nil ? 0 : 3
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell
            if opCell == nil {
                opCell = NewsHeaderCell()
            }
            let cell = opCell!
            if let np = self.newsPiece {
                cell.setCellInfo(np: np)
            }
            return cell
        } else if indexPath.row == 1 {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "NewsBodyCell", for: indexPath) as? NewsBodyCell
            if opCell == nil {
                opCell = NewsBodyCell()
            }
            let cell = opCell!
            if let np = self.newsPiece {
                cell.setCellInfo(np: np)
            }
            return cell
        } else {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "NewsFooterCell", for: indexPath) as? NewsFooterCell
            if opCell == nil {
                opCell = NewsFooterCell()
            }
            let cell = opCell!
            if let np = self.newsPiece {
                cell.setCellInfo(np: np)
            }
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = self.view.frame.width
        switch indexPath.row {
        case 0: return NewsHeaderCell.getCellHeight(cellWidth: width, text: self.newsPiece?.title ?? "")
        case 1: return NewsBodyCell.getCellHeight(cellWidth: width, text: self.newsPiece?.text ?? "")
        default: return 25
        }
    }

}
