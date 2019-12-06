//
//  UpDownCellTableViewCell.swift
//  PlantTree
//
//  Created by Admin on 28/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Eureka

class UpDownCellTableViewCell: Cell<Int>, CellType {
    var value : Int = 0
    var minValue = 0
    var maxValue = 10000
    var oneTreePrice : Double = 0.0
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOneTreePrice: UILabel!
    @IBOutlet weak var txtCount: UITextField!
    
    @IBAction func minusAction(_ sender: Any) {
        value -= 1
        update()
    }
    
    @IBAction func plusAction(_ sender: Any) {
        value += 1
        update()
    }
    @IBAction func countEditingEnded(_ sender: Any) {
        if let v = Int(string: txtCount.text!) {
            value = v
        }
        update()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case.
        // If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        
        // specify the desired height for our cell
        height = { return 220 }
        
        // set a light background color for our cell
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        if value < minValue {
            value = minValue
        }
        if value > maxValue {
            value = maxValue
        }
        txtCount.text = "\(value)"
        lblOneTreePrice.text = "Стоимость одного дерева: \(oneTreePrice)р"
        lblPrice.text = "Цена: \(value) x \(oneTreePrice) = \(Double(value) * oneTreePrice)"
    }
}
