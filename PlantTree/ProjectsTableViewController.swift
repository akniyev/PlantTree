//
//  ProjectsTableViewController.swift
//  PlantTree
//
//  Created by Admin on 20/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectsTableViewController : UITableViewController {
    var isEnd : Bool = false
    var projects : [ProjectInfo] = []

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var opCell = tableView.dequeueReusableCell(withIdentifier: "ProjectListCell", for: indexPath) as? ProjectCell
        if opCell == nil {
            opCell = ProjectCell()
        }
        var cell = opCell!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ProjectCell", bundle: nil), forCellReuseIdentifier: "ProjectListCell")
    }
}
