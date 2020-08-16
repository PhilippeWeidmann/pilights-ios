//
//  Recipe.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class Recipe {

    static let recipes = [
        Recipe(title: "Orecchiette brocoli-haricots verts", previewImage: UIImage(named: "bb1")!),
        Recipe(title: "Pain au bascilic", previewImage: UIImage(named: "bb2")!),
        Recipe(title: "Baudroie au beurre et au basilic", previewImage: UIImage(named: "bb3")!)]

    let title: String
    let previewImage: UIImage

    init(title: String, previewImage: UIImage) {
        self.title = title
        self.previewImage = previewImage
    }
}
