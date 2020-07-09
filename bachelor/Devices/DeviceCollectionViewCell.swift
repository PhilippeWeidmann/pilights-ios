//
//  DeviceCollectionViewCell.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
protocol DeviceCollectionViewCellDelegate {
    func didLongTouchWithDevice(_ device: Device)
    func didTapWithDevice(_ device: Device)
}
class DeviceCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var deviceIcon: UIImageView!
    @IBOutlet weak var deviceStateLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    var deepPressGestureRecognizer: DeepPressGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!

    var feedbackGenerator: UISelectionFeedbackGenerator?
    var scrollDelta = 0
    var device: Device!
    var delegate: DeviceCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.dropShadow(radius: 5, opacity: 0.25)
        shadowView.layer.cornerRadius = 15
        deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: #selector(DeviceCollectionViewCell.longGestureRecognised(_:)), threshold: 0.5)
        deepPressGestureRecognizer.delegate = self
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeviceCollectionViewCell.tapGestureRecognised(_:)))
        tapGestureRecognizer.delegate = self
        shadowView.addGestureRecognizer(tapGestureRecognizer)
        shadowView.addGestureRecognizer(deepPressGestureRecognizer)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func initWithDevice(_ device: Device) {
        self.device = device
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

    @objc func tapGestureRecognised(_ sender: UITapGestureRecognizer) {
        delegate?.didTapWithDevice(device)
    }

    @objc func longGestureRecognised(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            delegate?.didLongTouchWithDevice(device)
        } else if sender.state == .ended {
            feedbackGenerator = nil
        }

    }
}
