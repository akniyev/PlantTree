//
//  ProjectCell.swift
//  PlantTree
//
//  Created by Admin on 20/02/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import UIKit
import UICircularProgressRing
import Kingfisher

class ProjectCell: UITableViewCell {
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pbRemaining: UICircularProgressRingView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblSponsorCount: UILabel!


    var p : ProjectInfo? = nil
    var likeAction : ((ProjectInfo, UIButton, Int) -> ())?
    var id : Int = -1

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    @IBAction func likeTouched(_ sender: Any) {
        if let p = self.p {
            likeAction?(p, btnLike, id)
        }
    }

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
            btnLike.isEnabled = true
            lblTitle.text = p.name
            pbRemaining.value = CGFloat(p.reached)
            pbRemaining.maxValue = CGFloat(p.goal)
            lblLikeCount.text = "\(p.likeCount)"
            if p.isLikedByMe == true {
                btnLike.setImage(UIImage(named: "LikeActive"), for: .normal)
            } else {
                btnLike.setImage(UIImage(named: "LikeInactive"), for: .normal)
            }
            lblSponsorCount.text = p.sponsorCount.withRussianCountWord(one: "спонсон", tofour: "спонсора", overfour: "спонсоров")
        }
    }

    func LoadPhoto() {
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
