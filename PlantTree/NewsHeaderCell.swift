//
//  NewsHeaderCell.swift
//  PlantTree
//
//  Created by Admin on 24/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Kingfisher

class NewsHeaderCell: UITableViewCell {
    @IBOutlet weak var img_Photo: UIImageView!
    @IBOutlet weak var lbl_Title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellInfo(np: NewsPiece) {
        lbl_Title.text = np.title
        if !np.imageUrl.isEmpty {
            let url = URL(string: np.imageUrl)
            img_Photo.kf.indicatorType = .activity
            img_Photo.kf.setImage(with: url)
        }
    }
    
    static func getCellHeight(cellWidth: CGFloat, text: String) -> CGFloat {
        let labelSideIndent : CGFloat = 5
        let l = UILabel()
        l.font = UIFont(name: "Helvetica Neue", size: 21.0)
        l.numberOfLines = 0
        l.text = text
        let boundSize = CGSize(width: cellWidth - 2 * labelSideIndent, height: 1000000)
        let s = l.sizeThatFits(boundSize)
        return cellWidth * CGFloat(3.0 / 4.0) + s.height + 15.0
    }
    
}
