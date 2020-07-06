//
//  DeviceCollectionViewCell.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class DeviceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deviceIcon: UIImageView!
    @IBOutlet weak var deviceStateLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.dropShadow(radius: 5, opacity: 0.25)
        shadowView.layer.cornerRadius = 15
    }

    func initWithDevice(_ device: Device) {
        self.deviceNameLabel.text = device.name
        if device.type == .dimmableLight {
            if device.value == 0 {
                self.deviceIcon.image = UIImage(named: "lightoff")
                self.deviceStateLabel.text = "Éteint"
            } else {
                self.deviceIcon.image = UIImage(named: "lighton")
                self.deviceStateLabel.text = "\(device.value) %"
            }
        } else if device.type == .beacon {
            self.deviceIcon.image = UIImage(named: "beacon")
            self.deviceStateLabel.text = "Minor \(device.value)"
        }
    }
}
