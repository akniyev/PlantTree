//
//  PaymentHistoryViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class PaymentHistoryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var operations : [OperationInfo] = []
    var reloadView : ReloadView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "История операций"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryCell")
        tableView.separatorStyle = .none
        
        refreshPage()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") ?? PaymentHistoryCell()
        (c as? PaymentHistoryCell)?.setData(operation: operations[indexPath.row])
        return c
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PaymentHistoryCell.getCellHeight(cellWidth: tableView.frame.width, projectName: "Посадка деревьев в парке культуры и отдыха им. М. Горького")
    }
    
    func showReloadView() {
        if let v = getReloadView() {
            v.frame = self.view.bounds
            self.view.addSubview(v)
        }
    }
    
    func refreshPage() {
        hideReloadView()
        LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        //TODO: add pagination
        Server.GetOperationHistory(page: 1, pagesize: 10000, SUCCESS: { operations in
            self.operations = operations
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
            self.hideReloadView()
        }, ERROR: { et, msg in
            self.showReloadView()
            LoadingIndicatorView.hide()
        })
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
}
