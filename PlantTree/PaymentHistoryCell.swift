//
//  PaymentHistoryCell.swift
//  PlantTree
//
//  Created by Admin on 26/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class PaymentHistoryCell: UITableViewCell {
    @IBOutlet weak var lbl_LeftBadge: UILabel!
    @IBOutlet weak var lblDonated: UILabel!
    @IBOutlet weak var lblTreeCount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

//    let backgroundLayer : CAShapeLayer = CAShapeLayer()
    
    var operation : OperationInfo? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.lbl_LeftBadge.layer.mask = self.backgroundLayer
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
//        let path = UIBezierPath(ovalIn: self.lbl_LeftBadge.bounds)
//        self.backgroundLayer.path = path.cgPath
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func getCellHeight(cellWidth: CGFloat, projectName: String) -> CGFloat {
        return 70
//        let l = UILabel()
//        l.font = UIFont(name: "System", size: 17.0)
//        l.numberOfLines = 0
//        l.text = projectName
//        let s = l.sizeThatFits(CGSize(width: cellWidth - 2 * 8, height: 1000000))
//        return 66.0 + s.height + 10.0
    }
    
    func setData(operation: OperationInfo) {
        self.operation = operation
        lblTitle.text = operation.projectTitle
        lblDonated.text = "\(Int(operation.donated))р."
        lblTreeCount.text = "\(operation.treePlanted.withRussianCountWord(one: "дерево", tofour: "дерева", overfour: "деревьев"))"
        lbl_LeftBadge.text = "\(operation.treePlanted)"
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
}
