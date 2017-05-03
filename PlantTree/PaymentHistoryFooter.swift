//
//  PaymentHistoryFooter.swift
//  PlantTree
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit


class PaymentHistoryFooter : UITableViewHeaderFooterView {
    static func nibInstance() -> PaymentHistoryHeader? {
        if let paymentHeaderView = Bundle.main.loadNibNamed("PaymentHistoryFooter", owner: nil, options: nil)?.first as? PaymentHistoryHeader {
            return paymentHeaderView
        }
        return nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
}
