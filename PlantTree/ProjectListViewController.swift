//
//  ProjectListViewController.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var projects : [ProjectInfo] = []
    let rowHeight : Double = 230
    let pageSize = 10
    var loadedPagesCount = 0
    var endReached = false
    var currentlyLoading = false
    var signedOnLoading = true
    var reloadView : ReloadView? = nil
    var unauthorizedView : TableViewUnauthorized? = nil
    var tableView : UITableView = UITableView()
    var active = true
    var firstLaunch = true
    
    var projectToSegue : ProjectInfo? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    var projectListTypeCode : String = "active"
    
    @IBInspectable
    var segueName : String = ""
    
    var projectListType : ProjectListType = .active
    
    func pullRefreshPage() {
        refreshPage()
    }
    
    func refreshPage() {
        clearList()
        loadAdditionalPage()
    }
    
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
    
    func showUnauthorizedView() {
        if let v = getUnauthorizedView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }
    
    func hideUnauthorizedView() {
        if let v = unauthorizedView {
            v.removeFromSuperview()
        }
    }
    
    func getUnauthorizedView() -> TableViewUnauthorized? {
        if let unauthorizedView = Bundle.main.loadNibNamed("TableViewUnauthorized", owner: self, options: nil)?.first as? TableViewUnauthorized {
            self.unauthorizedView = unauthorizedView
            self.unauthorizedView?.authorizeAction = {
                self.tabBarController?.selectedIndex = 3
            }
        } else {
            self.unauthorizedView = nil
        }
        return self.unauthorizedView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ProjectCell)?.LoadPhoto()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ProjectCell)?.StopLoadingPhoto()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        projectToSegue = projects[indexPath.row]
        self.performSegue(withIdentifier: self.segueName, sender: self)
        return false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Double(scrollView.contentOffset.y + scrollView.contentInset.top)
        let pageHeight = rowHeight * Double(pageSize)
        
        let bottomOfFrame = offset + Double(scrollView.frame.height)
        let pageCountFractional = bottomOfFrame / pageHeight
        
        if pageCountFractional - Double(self.loadedPagesCount - 1) > 0.7 {
            self.loadAdditionalPage()
        }
    }
    
    func clearList() {
        projects.removeAll()
        loadedPagesCount = 0
        endReached = false
        self.tableView.reloadData()
    }
    
    func loadAdditionalPage() {
        if !active { return }
        if currentlyLoading || endReached { return }
        print("loading page!")
        
        hideReloadView()
        
        if !(self.tableView.refreshControl?.isRefreshing ?? false) && projects.isEmpty {
            LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        }
                
        signedOnLoading = Db.isAuthorized()
        
        currentlyLoading = true
        let pageToLoadNumber = loadedPagesCount + 1
        Server.GetProjectList(type: projectListType, page: pageToLoadNumber, pagesize: pageSize, SUCCESS: { ps in
            if ps.count > self.pageSize { return }
            self.projects.append(contentsOf: ps)
            self.loadedPagesCount = pageToLoadNumber
            self.endReached = ps.count < self.pageSize
            self.currentlyLoading = false
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
            LoadingIndicatorView.hide()
        }, ERROR: { et, msg in
            self.currentlyLoading = false
            self.tableView.refreshControl?.endRefreshing()
            self.showReloadView()
            LoadingIndicatorView.hide()
        })
    }
    
    func likeProject(p : ProjectInfo, b : UIButton, row: Int) {
        if Db.isAuthorized() && (p.isLikedByMe != nil) {
            let l = p.isLikedByMe!
            b.isEnabled = false
            if l {
                Server.Unlike(projectId: p.id, SUCCESS: {
                    self.projects[row].isLikedByMe = false
                    self.projects[row].likeCount -= 1
                    self.tableView.reloadData()
                }, ERROR: {
                    self.tableView.reloadData()
                })
            } else {
                Server.Like(projectId: p.id, SUCCESS: {
                    self.projects[row].isLikedByMe = true
                    self.projects[row].likeCount += 1
                    self.tableView.reloadData()
                }, ERROR: {
                    self.tableView.reloadData()
                })
            }
        } else {
            Alerts.ShowErrorAlertWithOK(sender: self, title: "Авторизация", message: "Необходимо авторизоваться для выполнения данного действия", completion: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as? ProjectCell
        if opCell == nil {
            opCell = ProjectCell()
        }
        let cell = opCell!
        
        cell.id = indexPath.row
        cell.SetProjectInfo(newP: projects[indexPath.row])
        cell.likeAction = { p, b, r in
            self.likeProject(p: p, b: b, row: r)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if projectListType == .favorites && !Db.isAuthorized() {
            active = false
            clearList()
            showUnauthorizedView()
        } else {
            hideUnauthorizedView()
            active = true
        }
        
        if projects.isEmpty && !endReached {
            firstLaunch = true
        }
        
        if firstLaunch || (signedOnLoading != Db.isAuthorized()) {
            firstLaunch = false
            clearList()
            loadAdditionalPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        
        if !projectListTypeCode.isEmpty {
            projectListType = ProjectListType.fromCode(code: projectListTypeCode)
        }
        signedOnLoading = Db.isAuthorized()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectListCell")
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullRefreshPage), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        if let detailVc = vc as? ProjectDetailsViewController {
            detailVc.projectId = projectToSegue?.id ?? -1
        }
    }
}
