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

    @IBOutlet weak var titleView: UIStackView!
    @IBOutlet weak var roomNameLabel: UILabel!
    var room: Room? {
        didSet {
            self.roomNameLabel.text = room?.name
        }
    }
    var delegate: RoomSectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnHeader(_:)))
        titleView.addGestureRecognizer(gestureRecognizer)
    }

    @IBAction func didTapOnHeader(_ sender: Any) {
        delegate?.didTapOnHeader?(self)
    }

}
