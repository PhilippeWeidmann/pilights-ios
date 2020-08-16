//
//  RoomDetailsSectionHeaderView.swift
//  bachelor
//
//  Created by Philippe Weidmann on 13.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class RoomDetailsSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var roomDetailsSubtitleLabel: UILabel!

    var delegate: RoomDetailsViewController?

    @IBAction func didPressLocationButton(_ sender: UIButton) {
        delegate?.headerViewDidPressLocationButton()
    }

}
