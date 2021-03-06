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
    static func storyboardInstance() -> ProjectDetailsViewController? {
        let storyboard = UIStoryboard(name: "ProjectDetails", bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProjectDetailsViewController
    }

    @IBAction func btnPlantTreeTouched(_ sender: Any) {
        if Db.isAuthorized() {
            self.performSegue(withIdentifier: "PAYMENT_SYSTEM", sender: self)
        } else {
            Alerts.ShowAlert(sender: self, title: "Ошибка", message: "Для совершения платежа необходимо войти в систему. Перейти на страницу входа?", preferredStyle: .alert, actions: [
                UIAlertAction(title: "Да", style: .default, handler: { [weak self] alertAction in
                    self?.tabBarController?.selectedIndex = 4
                    self?.navigationController?.popToRootViewController(animated: false)
                }),
                UIAlertAction(title: "Нет", style: .default, handler: nil)
                ], completion: nil)
        }
    }
    var projectId : Int = -1
    
    var parentViewControllerProjects : [ProjectInfo]? = nil
    var parentViewControllerProjectId = -1
    
    var projectDetailsCell : ProjectDetailsCell? = nil
    
    var newsIdForSegue = -1

    let newsPageSize = 15
    let newsUntilRefresh = 4
    var newsPagesLoaded = 0
    var endReached = false

    func loadAdditionalPage() {
        if !isLoading && !endReached, let p = self.project {
            print("Loading additional news page!")
            self.isLoading = true
            Server.GetProjectNews(projectId: p.id, page: self.newsPagesLoaded + 1, pageSize: self.newsPageSize, SUCCESS: { [weak self] news in
                p.news.append(contentsOf: news)
                self?.isLoading = false
                self?.endReached = news.count < (self?.newsPageSize ?? 0)
                self?.tvDetails.reloadData()
                self?.newsPagesLoaded += 1
            }, ERROR: { [weak self] et, msg in
                self?.isLoading = false
            })
        }
    }
    
    var project: ProjectInfo? = nil
    @IBOutlet weak var tvDetails: UITableView!
    @IBOutlet weak var btnPlantTree: UIButton!
    @IBOutlet weak var bottomTableViewConstraint: NSLayoutConstraint!

    var isLoading = false {
        didSet {
            self.tvDetails.reloadData()
        }
    }
    
    var reloadView : ReloadView? = nil

    func isLastRow(indexPath: IndexPath) -> Bool {
        let row = indexPath.row
        if let p = project {
            if p.news.count > 0 {
                return row == 2 + p.news.count
            } else {
                return row == 1
            }
        } else {
            return false
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = self.tvDetails.indexPathsForVisibleRows, let p = self.project {
            let maxRow = indexPaths.map{$0.row}.max() ?? 0
            let maxNewsRow = maxRow - 1
            let totalNewsRows = p.news.count
            let left = totalNewsRows - maxNewsRow
            if left < 4 {
                self.loadAdditionalPage()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvDetails.separatorStyle = .none
        self.tvDetails.register(UINib(nibName: "ProjectDetailsCell", bundle: nil), forCellReuseIdentifier: "ProjectDetailsCell")
        self.tvDetails.register(UINib(nibName: "ProjectNewsCell", bundle: nil), forCellReuseIdentifier: "ProjectNewsCell")
        self.tvDetails.register(UINib(nibName: "NewsBandSeparatorCell", bundle: nil), forCellReuseIdentifier: "NewsBandSeparatorCell")
        self.tvDetails.register(UINib(nibName: "ReloadIndicatorFooter", bundle: nil), forCellReuseIdentifier: "ReloadIndicatorFooter")

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
            Server.GetProjectDetailInfo(projectId: projectId, SUCCESS: { [weak self] project in
                self?.project = project
                self?.loadAdditionalPage()
                self?.tvDetails.reloadData()
                if project.projectStatus == .active {
                    self?.btnPlantTree.isHidden = false
                    self?.bottomTableViewConstraint.constant = (self?.btnPlantTree.frame.height ?? 0) - 1
                } else {
                    self?.btnPlantTree.isHidden = true
                    self?.bottomTableViewConstraint.constant = 0
                }
                LoadingIndicatorView.hide()
            }, ERROR: { [weak self] et, msg in
                //TODO: process this error in UI
                LoadingIndicatorView.hide()
                self?.showReloadView()
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
            var addition = self.isLoading ? 1 : 0
            if p.news.count > 0 {
                return 2 + p.news.count + addition
            } else {
                return 1 + addition
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isLastRow(indexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReloadIndicatorFooter") as! ReloadIndicatorFooter
            return cell
        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailsCell", for: indexPath) as! ProjectDetailsCell
            
            cell.setProjectInfo(pi: project!)
            projectDetailsCell = cell
            
            cell.likeAction = {
                let p = self.project!
                if Db.isAuthorized(), let l = p.isLikedByMe {
                    cell.btnLike.isEnabled = false
                    if l {
                        Server.Unlike(projectId: p.id, SUCCESS: {
                            self.project?.likeCount -= 1
                            self.parentViewControllerProjects?[self.parentViewControllerProjectId].isLikedByMe = false
                            self.parentViewControllerProjects?[self.parentViewControllerProjectId].likeCount = self.project?.likeCount ?? 0
                            self.project?.isLikedByMe = false
                            cell.btnLike.setImage(UIImage(named: "project_details_like_glowing_inactive"), for: .normal)
                            cell.btnLike.isEnabled = true
                            cell.setLikeCountLabel(count: self.project?.likeCount ?? 0)
                        }, ERROR: {
                            cell.btnLike.isEnabled = true
                        })
                    } else {
                        Server.Like(projectId: p.id, SUCCESS: {
                            self.project?.likeCount += 1
                            self.parentViewControllerProjects?[self.parentViewControllerProjectId].likeCount = self.project?.likeCount ?? 0
                            self.parentViewControllerProjects?[self.parentViewControllerProjectId].isLikedByMe = true
                            self.project?.isLikedByMe = true
                            cell.btnLike.setImage(UIImage(named: "project_details_like_glowing_active"), for: .normal)
                            cell.btnLike.isEnabled = true
                            cell.setLikeCountLabel(count: self.project?.likeCount ?? 0)
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
        if self.isLastRow(indexPath: indexPath) {
            return 40
        }
        if indexPath.row == 0 {
            return ProjectDetailsCell.getCellHeight(cellWidth: tableView.frame.width, text: project?.description ?? "123")
        } else if indexPath.row == 1 {
            return 50
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
