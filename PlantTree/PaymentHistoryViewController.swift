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

    var pagesLoaded = 0
    var isLoading = false
    var endReached = false

    let rowsOnPage = 12
    let minimumLeftRows = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "История операций"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryCell")
        tableView.register(UINib(nibName: "PaymentHistoryHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "PaymentHistoryHeader")
        tableView.register(UINib(nibName: "PaymentHistoryFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "PaymentHistoryFooter")
        tableView.separatorStyle = .none

        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(pullRefreshPage), for: .valueChanged)

        self.reloadAction()
    }

    func pullRefreshPage() {
        // Resetting all to initial state
        self.operations = []
        self.groupedOperations = [:]
        self.groupDates = []
        self.pagesLoaded = 0
        self.isLoading = false
        self.endReached = false
        self.tableView.reloadData()
        // Loading first page
        self.loadAdditionalPage()
    }

    func loadAdditionalPage() {
        if self.isLoading || self.endReached {
            return
        }
        print("loading additional news page!")
        self.isLoading = true
        Server.GetOperationHistory(page: pagesLoaded + 1, pagesize: rowsOnPage, SUCCESS: { [weak self] operations in
            print("***********")
            for o in operations {
                print(o.date)
            }
            if let S = self {
                S.operations.append(contentsOf: operations)
                S.groupedOperations = S.getGroupedOperations(from: S.operations)
                S.groupDates = S.groupedOperations.keys.sorted(by: {Date.fromRussianFormat(s: $0.0) ?? Date() > Date.fromRussianFormat(s: $0.1) ?? Date()})
                S.tableView.reloadData()
                LoadingIndicatorView.hide()
                S.hideReloadView()
                S.pagesLoaded += 1
                S.isLoading = false
                if operations.count < S.rowsOnPage {
                    S.endReached = true
                }
                S.tableView.refreshControl?.endRefreshing()
            }
        }, ERROR: { [weak self] et, msg in
            self?.showReloadView()
            self?.operations = []
            self?.groupedOperations = [:]
            self?.groupDates = []
            self?.pagesLoaded = 0
            LoadingIndicatorView.hide()
            self?.isLoading = false
            self?.endReached = false
            self?.tableView.refreshControl?.endRefreshing()
        })
    }

    override func reloadAction() {
        hideReloadView()
        LoadingIndicatorView.show(self.view, loadingText: "Загрузка...")
        loadAdditionalPage()
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

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPaths = self.tableView.indexPathsForVisibleRows {
            let maxSection = indexPaths.map{$0.section}.max() ?? 0
            let maxRow = indexPaths.map{$0.row}.max() ?? 0

            var numberOfRowsBeforeIndexPath = 0
            for i in 0..<maxSection {
                let d = self.groupDates[i]
                let rowCount = self.groupedOperations[d]?.count ?? 0
                numberOfRowsBeforeIndexPath += rowCount
            }
            numberOfRowsBeforeIndexPath += maxRow
            let rowsLeft = operations.count - numberOfRowsBeforeIndexPath
            if rowsLeft < self.minimumLeftRows {
                self.loadAdditionalPage()
            }
        }
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
            if let vc = ProjectDetailsViewController.storyboardInstance() {
                vc.projectId = operation.projectId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return false
    }
}
