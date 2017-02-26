//
//  ProjectDetailsViewController.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class ProjectDetailsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    var projectId : Int = -1
    
    var parentViewControllerProjects : [ProjectInfo] = []
    var parentViewControllerProjectId = -1
    
    var projectDetailsCell : ProjectDetailsCell? = nil
    
    var project: ProjectInfo? = nil
    @IBOutlet weak var tvDetails: UITableView!
    
    var reloadView : ReloadView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvDetails.separatorStyle = .none
        self.tvDetails.register(UINib(nibName: "ProjectDetailsCell", bundle: nil), forCellReuseIdentifier: "ProjectDetailsCell")
        self.tvDetails.register(UINib(nibName: "ProjectNewsCell", bundle: nil), forCellReuseIdentifier: "ProjectNewsCell")
        self.tvDetails.dataSource = self
        self.tvDetails.delegate = self
        
        self.navigationItem.title = "Проект"

        refreshPage()        
    }
    
    
    
    func showReloadView() {
        if let v = getReloadView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }
    
    func refreshPage() {
        hideReloadView()
        if projectId != -1 {
            LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
            Server.GetProjectDetailInfo(projectId: projectId, SUCCESS: { project in
                self.project = project
                self.tvDetails.reloadData()
                LoadingIndicatorView.hide()
            }, ERROR: { et, msg in
                //TODO: process this error in UI
                LoadingIndicatorView.hide()
                self.showReloadView()
            })
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let p = project {
            return 1 + p.news.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsCell", for: indexPath) as? ProjectDetailsCell
            if opCell == nil {
                opCell = ProjectDetailsCell()
            }
            let cell = opCell!
            
            cell.setProjectInfo(pi: project!)
            projectDetailsCell = cell
            
            cell.likeAction = {
                let p = self.project!
                if let l = p.isLikedByMe {
                    cell.btnLike.isEnabled = false
                    if l {
                        Server.Unlike(projectId: p.id, SUCCESS: {
                            self.parentViewControllerProjects[self.parentViewControllerProjectId].isLikedByMe = false
                            self.project?.isLikedByMe = false
                            cell.btnLike.setImage(UIImage(named: "LikeInactive"), for: .normal)
                            cell.btnLike.isEnabled = true
                        }, ERROR: {
                            cell.btnLike.isEnabled = true
                        })
                    } else {
                        Server.Like(projectId: p.id, SUCCESS: {
                            self.parentViewControllerProjects[self.parentViewControllerProjectId].isLikedByMe = true
                            self.project?.isLikedByMe = true
                            cell.btnLike.setImage(UIImage(named: "LikeActive"), for: .normal)
                            cell.btnLike.isEnabled = true
                        }, ERROR: {
                            cell.btnLike.isEnabled = true
                        })
                    }
                } else {
                    Alerts.ShowErrorAlertWithOK(sender: self, title: "Ошибка", message: "Необходимо авторизоваться для выполнения данного действия!", completion: nil)
                }
            }
            
            return cell
        } else {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectNewsCell", for: indexPath) as? ProjectNewsCell
            if opCell == nil {
                opCell = ProjectNewsCell()
            }
            let cell = opCell!
            
            cell.setNewsInfo(np: project!.news[indexPath.row - 1])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return ProjectDetailsCell.getCellHeight(cellWidth: tableView.frame.width, text: "one two tree four five six seven eight nine ten eleven twelve")
        } else {
            return ProjectNewsCell.getCellHeight(cellWidth: tableView.frame.width, title: "News title")
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let newsId = indexPath.row - 1
        if newsId > -1 {
            self.performSegue(withIdentifier: "showNews", sender: self)
        }
        
        return false
    }
}
