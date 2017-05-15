//
//  PlantTreeViewController2.swift
//  PlantTree
//
//  Created by Admin on 04/03/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit

class PlantTreeViewController2 : UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblTreePrice: UILabel!
    @IBOutlet weak var lblSum: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblRemaining: UILabel!
    
    @IBAction func btnPlusTouched(_ sender: Any) {
        plus()
    }
    
    @IBAction func btnMinusTouched(_ sender: Any) {
        minus()
    }
    
    @IBAction func btnPayTouched(_ sender: Any) {
        
    }
    
    var project : ProjectInfo? = nil
    var value = 1
    var maxValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Посадить деревья"
        btnPay.layer.cornerRadius = btnPay.frame.height / 2.0
        backView.layer.cornerRadius = 10
        if let p = project {
            maxValue = p.goal - p.reached
        }
        
        updateGuiInfo()
    }
    
    func updateGuiInfo() {
        btnMinus.isEnabled = !(value <= 1)
        btnPlus.isEnabled = !(value >= maxValue)
        
        if let p = project {
            lblTitle.text = p.name
            lblCount.text = "\(value)"
            lblRemaining.text = "\(p.goal - p.reached - value) доступно"
            lblTreePrice.text = "Стоимость одного дерева: \(p.treePrice) р"
            lblSum.text = "\(p.treePrice * Double(value)) р"
        }
    }
    
    func plus() {
        if value < maxValue {
            value += 1
            updateGuiInfo()
        }
    }
    
    func minus() {
        if value > 1 {
            value -= 1
            updateGuiInfo()
        }
    }
}
