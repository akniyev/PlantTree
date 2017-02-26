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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "История операций"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil), forCellReuseIdentifier: "PaymentHistoryCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") ?? PaymentHistoryCell()
        
        return c
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PaymentHistoryCell.getCellHeight(cellWidth: tableView.frame.width, projectName: "Посадка деревьев в парке культуры и отдыха им. М. Горького")
    }
}
