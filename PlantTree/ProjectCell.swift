//
//  ProjectCell.swift
//  PlantTree
//
//  Created by Admin on 20/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ProjectCell: UITableViewCell {
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pbRemaining: UICircularProgressRingView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnLike: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
