//
//  RoomSectionHeaderView.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

@objc protocol RoomSectionDelegate {
    @objc optional func didTapOnHeader(_ header: RoomSectionHeaderView)
}

class RoomSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var roomNameLabel: UILabel!
    var room: Room? {
        didSet {
            self.roomNameLabel.text = room?.name
        }
    }
    var delegate: RoomSectionDelegate?

    @IBAction func didTapOnHeader(_ sender: UIButton) {
        delegate?.didTapOnHeader?(self)
    }


}
