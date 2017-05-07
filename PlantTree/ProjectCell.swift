//
//  ProjectCell.swift
//  PlantTree
//
//  Created by Admin on 20/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import Kingfisher

class ProjectCell: UITableViewCell {
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
//    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblSponsorCount: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!


    var p : ProjectInfo? = nil
//    var likeAction : ((ProjectInfo, UIButton, Int) -> ())?
    var id : Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
//    @IBAction func likeTouched(_ sender: Any) {
//        if let p = self.p {
//            likeAction?(p, btnLike, id)
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func SetProjectInfo(newP : ProjectInfo) {
        self.p = newP
        RefreshProjectInfo()
    }
    
    func RefreshProjectInfo() {
        if let p = self.p {
//            btnLike.isEnabled = true
            lblTitle.text = p.name
            lblCount.text = p.projectStatus == ProjectStatus.active ? "\(p.reached)/\(p.goal)" : "\(p.reached)"
            if p.projectStatus == .active {
                lblCount.textColor = UIColor.darkText
                lblStatus.textColor = UIColor.darkText
            } else if p.projectStatus == .collected {
                lblCount.textColor = UIColor.orange
                lblStatus.textColor = UIColor.orange
            } else {
                lblCount.textColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)
                lblStatus.textColor = UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 125.0/255.0, alpha: 1.0)
            }
            print(p.projectStatus)
            lblStatus.text = p.projectStatus == ProjectStatus.finished ? "посажено" : "собрано"
            lblLikeCount.text = "\(p.likeCount)"
//            if p.isLikedByMe == true {
//                btnLike.setImage(UIImage(named: "LikeActive"), for: .normal)
//            } else {
//                btnLike.setImage(UIImage(named: "LikeInactive"), for: .normal)
//            }
            lblSponsorCount.text = p.sponsorCount.withRussianCountWord(one: "спонсон", tofour: "спонсора", overfour: "спонсоров")
        }
    }

    func LoadPhoto() {
        imgPicture.image = nil
        if let p = self.p {
            if !p.mainImageUrlSmall.isEmpty {
                let url = URL(string: p.mainImageUrlSmall)
                imgPicture.kf.indicatorType = .activity
                imgPicture.kf.setImage(with: url)
            }
        }
    }

    func StopLoadingPhoto() {
        imgPicture.kf.cancelDownloadTask()
    }


}
