//
//  ReloadIndicatorFooter.swift
//  PlantTree
//
//  Created by Hasan on 09/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class ReloadIndicatorFooter : UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.startAnimating()
    }
}
