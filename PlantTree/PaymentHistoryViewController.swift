//
//  PaymentHistoryViewController.swift
//  PlantTree
//
//  Created by Admin on 17/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class PaymentHistoryViewController : ReloadableViewController, UITableViewDelegate, UITableViewDataSource {
    static func storyboardInstance() -> PaymentHistoryViewController? {
        let storyboard = UIStoryboard(name: "PaymentHistory", bundle: nil)
        return storyboard.instantiateInitialViewController() as? PaymentHistoryViewController
    }

    @IBOutlet weak var tableView: UITableView!

    var operations: [OperationInfo] = []
    var groupedOperations: [String:[OperationInfo]] = [:]
    var groupDates: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "История операций"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryCell")
        tableView.register(UINib(nibName: "PaymentHistoryHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "PaymentHistoryHeader")
        tableView.register(UINib(nibName: "PaymentHistoryFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "PaymentHistoryFooter")
        tableView.separatorStyle = .none

        self.reloadAction()
    }

    override func reloadAction() {
        hideReloadView()
        LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        //TODO: add pagination
        Server.GetOperationHistory(page: 1, pagesize: 10000, SUCCESS: { operations in
            self.operations = operations
            self.groupedOperations = self.getGroupedOperations(from: self.operations)
            self.groupDates = self.groupedOperations.keys.sorted().reversed()
            self.tableView.reloadData()
            LoadingIndicatorView.hide()
            self.hideReloadView()
        }, ERROR: { et, msg in
            self.showReloadView()
            LoadingIndicatorView.hide()
        })
    }

    func getGroupedOperations(from operations: [OperationInfo]) -> [String:[OperationInfo]] {
        var result : [String:[OperationInfo]] = [:]
        for operation in operations {
            if result[operation.date.toRussianFormat()] != nil {
                result[operation.date.toRussianFormat()]?.append(operation)
            } else {
                result[operation.date.toRussianFormat()] = [operation]
            }
        }
        return result
    }

    // Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupDates.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = self.groupDates[section]
        return self.groupedOperations[date]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = self.groupDates[indexPath.section]
        let c: PaymentHistoryCell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") as? PaymentHistoryCell ?? PaymentHistoryCell()
        c.setData(operation: self.groupedOperations[date]![indexPath.row])
        c.layoutSubviews()
        return c
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PaymentHistoryCell.getCellHeight(cellWidth: tableView.frame.width, projectName: "Посадка деревьев в парке культуры и отдыха им. М. Горького")
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view: PaymentHistoryHeader? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PaymentHistoryHeader") as? PaymentHistoryHeader

        if view == nil {
            view = PaymentHistoryHeader()
        }

        let date = self.groupDates[section]

        view?.txt_Label.text = Date.fromRussianFormat(s: date)?.toLongRussianFormat() ?? ""

        return view!
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view: PaymentHistoryFooter? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PaymentHistoryFooter") as? PaymentHistoryFooter

        if view == nil {
            view = PaymentHistoryFooter()
        }

        return view!
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 60 : 40
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let groupName = self.groupDates[indexPath.section]
        if let operation = self.groupedOperations[groupName]?[indexPath.row] {
            print("highlight \(operation.projectTitle)")
            if let vc = ProjectDetailsViewController.storyboardInstance() {
                vc.projectId = operation.projectId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return false
    }

}
