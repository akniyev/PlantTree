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
    
    var newsIdForSegue = -1
    
    var project: ProjectInfo? = nil
    @IBOutlet weak var tvDetails: UITableView!
    @IBOutlet weak var btnPlantTree: UIButton!
    @IBOutlet weak var bottomTableViewConstraint: NSLayoutConstraint!
    
    var reloadView : ReloadView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvDetails.separatorStyle = .none
        self.tvDetails.register(UINib(nibName: "ProjectDetailsCell", bundle: nil), forCellReuseIdentifier: "ProjectDetailsCell")
        self.tvDetails.register(UINib(nibName: "ProjectNewsCell", bundle: nil), forCellReuseIdentifier: "ProjectNewsCell")
        self.tvDetails.register(UINib(nibName: "NewsBandSeparatorCell", bundle: nil), forCellReuseIdentifier: "NewsBandSeparatorCell")
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
                if project.projectStatus == .active {
                    self.btnPlantTree.isHidden = false
                    self.bottomTableViewConstraint.constant = self.btnPlantTree.frame.height - 1
                } else {
                    self.btnPlantTree.isHidden = true
                    self.bottomTableViewConstraint.constant = 0
                }
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
            if p.news.count > 0 {
                return 2 + p.news.count
            } else {
                return 1
            }
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
                if Db.isAuthorized(), let l = p.isLikedByMe {
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
        } else if indexPath.row == 1 {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "NewsBandSeparatorCell", for: indexPath) as? NewsBandSeparatorCell
            if opCell == nil {
                opCell = NewsBandSeparatorCell()
            }
            let cell = opCell!
            
            return cell
        } else {
            var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectNewsCell", for: indexPath) as? ProjectNewsCell
            if opCell == nil {
                opCell = ProjectNewsCell()
            }
            let cell = opCell!
            
            cell.setNewsInfo(np: project!.news[indexPath.row - 2])
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return ProjectDetailsCell.getCellHeight(cellWidth: tableView.frame.width, text: project?.description ?? "123")
        } else if indexPath.row == 1 {
            return 40
        } else {
            return ProjectNewsCell.getCellHeight(cellWidth: tableView.frame.width, title: project?.news[indexPath.row - 2].title ?? "123")
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let newsId = indexPath.row - 2
        if newsId > -1 {
            self.newsIdForSegue = newsId
            self.performSegue(withIdentifier: "showNews", sender: self)
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = (segue.destination as? NewsViewController) {
            if let p = project {
                vc.newsId = p.news[newsIdForSegue].id
            }
        } else if let vc = (segue.destination as? PlantTreeViewController2) {
            vc.project = project
        }
    }
}
