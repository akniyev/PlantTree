//
//  PaymentHistoryCell.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getCellHeight(cellWidth: CGFloat, projectName: String) -> CGFloat {
        let l = UILabel()
        l.font = UIFont(name: "System", size: 17.0)
        l.numberOfLines = 0
        l.text = projectName
        let s = l.sizeThatFits(CGSize(width: cellWidth - 2 * 8, height: 1000000))
        return 66.0 + s.height + 10.0
    }
    
}
