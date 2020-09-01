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
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var tapGestureRecognizer: UITapGestureRecognizer!

    var feedbackGenerator: UISelectionFeedbackGenerator?
    var scrollDelta = 0
    var device: Device!
    var delegate: DeviceCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.dropShadow(radius: 5, opacity: 0.25)
        shadowView.layer.cornerCurve = .continuous
        shadowView.layer.cornerRadius = 15
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DeviceCollectionViewCell.tapGestureRecognised(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        shadowView.addGestureRecognizer(tapGestureRecognizer)
        if traitCollection.forceTouchCapability == .available && !Platform.isSimulator {
            deepPressGestureRecognizer = DeepPressGestureRecognizer(target: self, action: #selector(DeviceCollectionViewCell.longGestureRecognised(_:)), threshold: 0.5)
            deepPressGestureRecognizer.delegate = self
            deepPressGestureRecognizer.cancelsTouchesInView = true
            shadowView.addGestureRecognizer(deepPressGestureRecognizer)
        } else {
            longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DeviceCollectionViewCell.longGestureRecognised(_:)))
            longPressGestureRecognizer.delegate = self
            longPressGestureRecognizer.cancelsTouchesInView = true
            shadowView.addGestureRecognizer(longPressGestureRecognizer)
        }

    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func initWithDevice(_ device: Device) {
        self.device = device
        deviceNameLabel.text = device.name
        switch device.type {
        case .dimmableLight:
            if device.value == 0 {
                deviceIcon.image = UIImage(named: "lightoff")
                deviceStateLabel.text = "Éteint"
            } else {
                deviceIcon.image = UIImage(named: "lighton")
                deviceStateLabel.text = "\(device.value) %"
            }
            break
        case .beacon:
            deviceIcon.image = UIImage(named: "beacon")
            deviceStateLabel.text = "Minor \(device.value)"
            break
        case .thermometer:
            deviceIcon.image = UIImage(named: "thermometer")
            deviceStateLabel.text = "\(device.value)°C"
            break
        case .light:
            if device.value == 0 {
                deviceIcon.image = UIImage(named: "lightoff")
                deviceStateLabel.text = "Éteint"
            } else {
                deviceIcon.image = UIImage(named: "lighton")
                deviceStateLabel.text = "Allumé"
            }
            break
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
