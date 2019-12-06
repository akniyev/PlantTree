//
//  ProjectListViewController.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var projectsGrouped : [[ProjectInfo]] = []
    var projects : [ProjectInfo] {
        get {
            return Array(projectsGrouped.joined())
        }
    }
    let rowHeight : Double = 230
    let pageSize = 10
    var loadedPagesCount : Int {
        get {
            return self.projectsGrouped.count
        }
    }
    var endReached = false
    var currentlyLoading = false
    var signedOnLoading = true
    var reloadView : ReloadView? = nil
    var unauthorizedView : ReloadView? = nil
    var tableView : UITableView = UITableView()
    var active = true
    var firstLaunch = true
    
    var projectToSegue : ProjectInfo? = nil
    var projectIndexToSegue : Int = -1

    var showReloadIndicator = false {
        didSet {
            self.tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable
    var projectListTypeCode : String = "active"
    
    @IBInspectable
    var segueName : String = ""
    
    var projectListType : ProjectListType = .active
    
    @objc func pullRefreshPage() {
        refreshPage()
    }
    
    func refreshPage() {
        clearList()
        loadPage()
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
    
    func getUnauthorizedView() -> ReloadView? {
        if let unauthorizedView = Bundle.main.loadNibNamed("ReloadView", owner: self, options: nil)?.first as? ReloadView {
            self.unauthorizedView = unauthorizedView
            self.unauthorizedView?.lbl_Text.text = "Необходимо авторизоваться для доступа к данному разделу! Нажмите сюда для авторизации."
            self.unauthorizedView?.reloadAction = { [weak self] in
                self?.tabBarController?.selectedIndex = 4
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
        if indexPath.row == self.projects.count {
            return false
        }
        
        if let vc = ProjectDetailsViewController.storyboardInstance() {
            let p = projects[indexPath.row]

            vc.projectId = p.id
            vc.parentViewControllerProjects = self.projects
            vc.parentViewControllerProjectId = indexPath.row

            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count + (self.showReloadIndicator ? 1 : 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Double(scrollView.contentOffset.y + scrollView.contentInset.top)
        let pageHeight = rowHeight * Double(pageSize)
        
        let bottomOfFrame = offset + Double(scrollView.frame.height)
        let pageCountFractional = bottomOfFrame / pageHeight
        
        if pageCountFractional - Double(self.loadedPagesCount - 1) > 0.7 {
            self.loadPage()
        }
    }
    
    func clearList() {
        projectsGrouped.removeAll()
        endReached = false
        self.tableView.reloadData()
    }

    // page = 0, 1, ...
    func loadPage(page: Int = -1) {
        if !active { return }
        if page == -1 && (currentlyLoading || endReached) {
            return
        }

        if self.loadedPagesCount > 0 {
            self.showReloadIndicator = true
        }
        
        hideReloadView()
        
        if !(self.tableView.refreshControl?.isRefreshing ?? false) && projects.isEmpty {
            LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        }
                
        signedOnLoading = Db.isAuthorized()
        
        currentlyLoading = true
        let pageToLoadNumber = page == -1 ? loadedPagesCount + 1 : page
        Server.GetProjectList(type: projectListType, page: pageToLoadNumber, pagesize: pageSize, SUCCESS: { [weak self] ps in
            if ps.count > (self?.pageSize ?? 0)! { return }
            if page == -1 {
                self?.projectsGrouped.append(ps)
            } else {
                self?.projectsGrouped[page] = ps
                if let count = self?.projectsGrouped.count, let pageSize = self?.pageSize {
                    if page == count - 1 && ps.count == pageSize {
                        self?.endReached = false
                    }
                }
            }
            self?.endReached = ps.count < self?.pageSize ?? 0
            self?.currentlyLoading = false
            self?.tableView.reloadData()
            self?.tableView.refreshControl?.endRefreshing()
            self?.showReloadIndicator = false
            LoadingIndicatorView.hide()
        }, ERROR: { [weak self] et, msg in
            self?.currentlyLoading = false
            self?.tableView.refreshControl?.endRefreshing()
            self?.showReloadView()
            self?.showReloadIndicator = false
            LoadingIndicatorView.hide()      })
    }

    func visiblePages() -> [Int] {
        let visibleItems : [IndexPath] = self.tableView.indexPathsForVisibleRows ?? []
        let minRow = visibleItems.map{$0.row}.min() ?? 0
        let maxRow = visibleItems.map{$0.row}.max() ?? 0

        let minPage: Int = minRow / self.pageSize
        let maxPage: Int = maxRow / self.pageSize
        
        return Array(minPage...maxPage)
    }

//    func reloadVisiblePages() {
//        let pages = self.visiblePages()
//        for page in pages {
//            self.loadPage(page: page)
//        }
//    }
    
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
        if self.showReloadIndicator && indexPath.row == projects.count {
            let opCell = tableView.dequeueReusableCell(withIdentifier: "ReloadIndicatorFooter") as! ReloadIndicatorFooter
            return opCell
        }

        var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as? ProjectCell
        if opCell == nil {
            opCell = ProjectCell()
        }
        let cell = opCell!
        
        cell.id = indexPath.row
        cell.SetProjectInfo(newP: projects[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == projects.count ? 40 : CGFloat(rowHeight)
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
            loadPage()
        } else {
            tableView.reloadData()
//            self.reloadVisiblePages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.view.addSubview(self.tableView)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 0, right: 0)
        
        if !projectListTypeCode.isEmpty {
            projectListType = ProjectListType.fromCode(code: projectListTypeCode)
        }
        signedOnLoading = Db.isAuthorized()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectListCell")
        self.tableView.register(UINib(nibName: "ReloadIndicatorFooter", bundle: nil), forCellReuseIdentifier: "ReloadIndicatorFooter")
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullRefreshPage), for: .valueChanged)
    }
}
