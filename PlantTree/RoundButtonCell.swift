//
//  RoundButtonCell.swift
//  PlantTree
//
//  Created by Admin on 04/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class RoundButtonCell: Cell<String>, CellType {
    @IBOutlet weak var roundButton: RoundBorderButton!
    
    @IBAction func roundButtonPressed(_ sender: Any) {
        (self.baseRow as? RoundButtonRow)?.action?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
