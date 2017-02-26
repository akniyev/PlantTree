//
//  ProjectDetailsCell.swift
//  PlantTree
//
//  Created by Admin on 25/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProjectDetailsCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblReached: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    
    var likeAction : (()->())? = nil
    
    @IBAction func likeTouched(_ sender: Any) {
        likeAction?()
    }
    
    static func getCellHeight(cellWidth: CGFloat, text: String) -> CGFloat {
        let labelSideIndent : CGFloat = 8
        let l = UILabel()
        l.font = UIFont(name: "System", size: 15.0)
        l.numberOfLines = 0
        l.text = text
        let s = l.sizeThatFits(CGSize(width: cellWidth - 2 * labelSideIndent, height: 1000000))
        return cellWidth * CGFloat(3.0 / 4.0) + 88.0 + s.height + 8.0 + 2.0
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didOpenFullImage))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        slideshow.contentScaleMode = .scaleAspectFill
    }
    
    func didOpenFullImage() {
        if let pvc = self.parentViewController {
            slideshow.presentFullScreenController(from: pvc)
        }
    }
    
    func setProjectInfo(pi: ProjectInfo) {
        lblDescription.text = pi.description
        lblTitle.text = pi.name
        lblReached.text = "\(pi.reached)/\(pi.goal)"
        var slideshowSources : [KingfisherSource] = []
        for i in pi.allImages {
            slideshowSources.append(KingfisherSource(urlString: i)!)
        }
        slideshow.setImageInputs(slideshowSources)
        
        if pi.isLikedByMe == true {
            btnLike.setImage(UIImage(named: "LikeActive"), for: .normal)
        } else {
            btnLike.setImage(UIImage(named: "LikeInactive"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
