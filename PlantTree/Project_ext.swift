//
//  Project.swift
//  PlantTree
//
//  Created by Admin on 07/04/2017.
//  Copyright © 2017 greenworld. All rights reserved.
//

import Foundation

extension Project {
    func toProjectInfo() -> ProjectInfo {
        let pi = ProjectInfo()
        let p = self
        pi.id = Int(p.id ?? -1)
        pi.name = p.name ?? ""
        pi.goal = Int(p.goal ?? 0)
        pi.reached = Int(p.reached ?? 0)
        pi.projectStatus = ProjectStatus.fromString(s: p.status ?? "")
        // TODO: remove this http prefixes and make server to send it
        pi.mainImageUrlSmall = "http://" + (p.mainImageUrlSmall ?? "")
        pi.mainImageUrlBig = "http://" + (p.mainImageUrl ?? "")
        pi.likeCount = Int(p.likesCount ?? 0)
        pi.isLikedByMe = p.isLiked ?? false
        pi.treePrice = p.treePrice ?? 0.0
        pi.sponsorCount = Int(p.donatorsCount ?? 0)
        pi.news = []
        pi.description = p.description ?? ""
        var allImages : [String] = []
        if p.mainImageUrl != nil {
            allImages.append("http://" + p.mainImageUrl!)
        }
        allImages.append(contentsOf: p.otherImagesUrl ?? [])
        pi.allImages = allImages
        return pi
    }
}
