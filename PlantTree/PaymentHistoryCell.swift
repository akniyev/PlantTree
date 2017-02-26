//
//  PaymentHistoryCell.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblDonated: UILabel!
    @IBOutlet weak var lblTreeCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var operation : OperationInfo? = nil

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
    
    func setData(operation: OperationInfo) {
        self.operation = operation
        lblTitle.text = operation.projectTitle
        lblDate.text = "\(operation.date.toRussianFormat())"
        lblDonated.text = "\(Int(operation.donated))р."
        lblTreeCount.text = "\(operation.treePlanted)"
        lblCard.text = "Карта: **** \(operation.cardLastDigits)"
    }
}
