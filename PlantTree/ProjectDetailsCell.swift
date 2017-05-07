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
    @IBOutlet weak var lblSponsorsCount: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblCollected: UILabel!
    
    var likeAction : (()->())? = nil
    
    @IBAction func likeTouched(_ sender: Any) {
        likeAction?()
    }
    
    static func getCellHeight(cellWidth: CGFloat, text: String) -> CGFloat {
        let labelSideIndent : CGFloat = 8
        let l = UILabel()
        l.font = UIFont(name: "Helvetica Neue", size: 15.0)
        l.numberOfLines = 0
        l.text = text
        let boundSize = CGSize(width: cellWidth - 2 * labelSideIndent, height: 1000000)
        let s = l.sizeThatFits(boundSize)
        return cellWidth * CGFloat(3.0 / 4.0) + 86.0 + s.height + 8.0 + 2.0
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
            let kfs = KingfisherSource(urlString: i)
            if let kingfisherSource = kfs {
                slideshowSources.append(kingfisherSource)
            }
        }
        slideshow.setImageInputs(slideshowSources)

        if pi.isLikedByMe == true {
            btnLike.setImage(UIImage(named: "project_details_like_glowing_active"), for: .normal)
        } else {
            btnLike.setImage(UIImage(named: "project_details_like_glowing_inactive"), for: .normal)
        }

        switch pi.projectStatus {
        case .active:
            lblStatus.text = "Статус: сбор денег"
            lblStatus.textColor = UIColor.darkText
            lblReached.textColor = UIColor.darkText
            lblCollected.textColor = UIColor.darkText
        case .collected:
            lblStatus.text = "Статус: деньги собраны"
            lblStatus.textColor = UIColor.orange
            lblReached.textColor = UIColor.orange
            lblCollected.textColor = UIColor.orange
        case .finished:
            lblStatus.text = "Статус: завершен"
            lblStatus.textColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)
            lblReached.textColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)
            lblCollected.textColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        case .none:
            lblStatus.text = ""
        }

        setLikeCountLabel(count: pi.likeCount)
        lblSponsorsCount.text = pi.likeCount.withRussianCountWord(one: "спонсор", tofour: "спонсора", overfour: "спонсоров")
    }

    func setLikeCountLabel(count: Int) {
        lblLikeCount.text = count.withRussianCountWord(one: "лайк", tofour: "лайка", overfour: "лайков")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
