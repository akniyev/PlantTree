//
//  ProjectNewsCell.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ProjectNewsCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var newsPiece : NewsPiece? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setNewsInfo(np : NewsPiece) {
        lblTitle.text = np.title
        lblDate.text = "Дата публикации: \(np.date?.toRussianFormat() ?? "")"
        let url = URL(string: np.imageUrl)
        img.kf.setImage(with: url)
        self.newsPiece = np
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getCellHeight(cellWidth: CGFloat, title: String) -> CGFloat {
        let l = UILabel()
        l.font = UIFont(name: "Helvetica Neue", size: 17.0)
        l.numberOfLines = 0
        l.text = title
        let s = l.sizeThatFits(CGSize(width: cellWidth - 2 * 8, height: 1000000))
        return cellWidth * CGFloat(9.0 / 20.0) + 8.0 + s.height + 3.0 + 21.0 + 8.0 + 2.0
    }
    
}
