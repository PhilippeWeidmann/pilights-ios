//
//  WidgetCollectionViewCell.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class WidgetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentInsetView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentInsetView.dropShadow(radius: 5, opacity: 0.25)
        contentInsetView.layer.cornerCurve = .continuous
        contentInsetView.layer.cornerRadius = 15
        
    }

}
