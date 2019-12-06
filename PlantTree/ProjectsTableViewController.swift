//
//  ProjectsTableViewController.swift
//  PlantTree
//
//  Created by Admin on 20/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectsTableViewController : UITableViewController {
    var projects : [ProjectInfo] = []
    let rowHeight : Double = 230
    let pageSize = 10
    var loadedPagesCount = 0
    var endReached = false
    var currentlyLoading = false
    var signedOnLoading = true
    var reloadView : ReloadView? = nil
    
    var projectToSegue : ProjectInfo? = nil
    
    @IBInspectable
    var projectListTypeCode : String = "active"
    
    var projectListType : ProjectListType = .active
    
    @objc func pullRefreshPage() {
        refreshPage()
    }
    
    func showReloadView() {
        if let v = getReloadView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }
    
    func refreshPage() {
        clearList()
        loadAdditionalPage()
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

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ProjectCell)?.LoadPhoto()
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? ProjectCell)?.StopLoadingPhoto()
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        print(indexPath.row)
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = Double(scrollView.contentOffset.y + scrollView.contentInset.top)
        let pageHeight = rowHeight * Double(pageSize)

        let bottomOfFrame = offset + Double(scrollView.frame.height)
        let pageCountFractional = bottomOfFrame / pageHeight

        if pageCountFractional - Double(self.loadedPagesCount - 1) > 0.7 {
            self.loadAdditionalPage()
        }
        //print(pageCountFractional - Double(self.loadedPagesCount - 1))
    }

    func clearList() {
        projects.removeAll()
        loadedPagesCount = 0
        endReached = false
        self.tableView.reloadData()
    }
    
    func loadAdditionalPage() {
        if currentlyLoading || endReached { return }
        print("loading page!")
        
        hideReloadView()
        
        if projects.count == 0 {
            self.refreshControl?.beginRefreshing()
            //self.tableView.setContentOffset(CGPoint(x: 0, y: self.tableView.contentOffset.y-(self.refreshControl?.frame.size.height ?? 0)), animated: false)
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
            self.refreshControl?.endRefreshing()
        }, ERROR: { et, msg in
            self.currentlyLoading = false
            self.refreshControl?.endRefreshing()
            self.showReloadView()
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


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as? ProjectCell
        if opCell == nil {
            opCell = ProjectCell()
        }
        let cell = opCell!

        cell.id = indexPath.row
        cell.SetProjectInfo(newP: projects[indexPath.row])
//        cell.likeAction = { p, b, r in
//            self.likeProject(p: p, b: b, row: r)
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if signedOnLoading != Db.isAuthorized() {
            clearList()
            loadAdditionalPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !projectListTypeCode.isEmpty {
            projectListType = ProjectListType.fromCode(code: projectListTypeCode)
        }
        signedOnLoading = Db.isAuthorized()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectListCell")
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(pullRefreshPage), for: .valueChanged)
        
        self.loadAdditionalPage()
//        Server.GetProjectList(type: projectListType, page: 1, pagesize: pageSize, SUCCESS: { ps in
//            
//        }, ERROR: { et, msg in
//            Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: msg, completion: nil)
//        })
    }
}
