//
//  NewsBodyCell.swift
//  PlantTree
//
//  Created by Admin on 24/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class NewsBodyCell: UITableViewCell {
    @IBOutlet weak var lbl_Text: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getCellHeight(cellWidth: CGFloat, text: String) -> CGFloat {
        let labelSideIndent : CGFloat = 5
        let labelHeightIndent : CGFloat = 15
        let l = UILabel()
        l.font = UIFont(name: "Helvetica Neue", size: 17.0)
        l.numberOfLines = 0
        l.text = text
        let boundSize = CGSize(width: cellWidth - 2 * labelSideIndent, height: 1000000)
        let s = l.sizeThatFits(boundSize)
        return s.height + 2.0 + labelHeightIndent * 2
    }

    func setCellInfo(np: NewsPiece) {
        lbl_Text.text = np.text
    }
}
