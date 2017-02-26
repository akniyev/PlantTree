//
//  ProjectNewsCell.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectNewsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getCellHeight(cellWidth: CGFloat, title: String) -> CGFloat {
        let l = UILabel()
        l.font = UIFont(name: "System", size: 17.0)
        l.numberOfLines = 0
        l.text = title
        let s = l.sizeThatFits(CGSize(width: cellWidth - 2 * 8, height: 1000000))
        return cellWidth * CGFloat(9.0 / 20.0) + 8.0 + s.height + 3.0 + 21.0 + 2.0
    }
    
}
