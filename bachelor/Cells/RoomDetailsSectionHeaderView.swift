//
//  RoomDetailsSectionHeaderView.swift
//  bachelor
//
//  Created by Philippe Weidmann on 13.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class RoomDetailsSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var headerView: UIStackView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var roomDetailsSubtitleLabel: UILabel!

    var delegate: RoomDetailsViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressLocationButton(_:)))
        headerView.addGestureRecognizer(gestureRecognizer)
    }

    @IBAction func didPressLocationButton(_ sender: Any) {
        delegate?.headerViewDidPressLocationButton()
    }

}
