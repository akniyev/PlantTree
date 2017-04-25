//
//  NewsFooterCell.swift
//  PlantTree
//
//  Created by Admin on 24/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class NewsFooterCell: UITableViewCell {
    @IBOutlet weak var lbl_Date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellInfo(np: NewsPiece) {
        self.lbl_Date.text = np.date?.toRussianFormat() ?? ""
    }
}
