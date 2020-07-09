//
//  DeviceDetailsViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 09.07.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import TactileSlider
import PanModal

class DeviceControlViewController: UIViewController, PanModalPresentable {

    var panScrollable: UIScrollView?
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }

    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceStateLabel: UILabel!
    @IBOutlet weak var deviceSlider: TactileSlider!

    var device: Device!

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceSlider.minimum = 0
        deviceSlider.maximum = 100
        deviceSlider.feedbackStyle = .light
        deviceSlider.setValue(Float(device.value), animated: true)
        deviceSlider.tintColor = UIColor(named: "yellowColor")
        deviceNameLabel.text = device.name
        updateDeviceIconAndState()
    }
    
    func updateDeviceIconAndState() {
        if device.type == .dimmableLight {
            if device.value == 0 {
                deviceImageView.image = UIImage(named: "lightoff")
                self.deviceStateLabel.text = "Éteint"
            } else {
                deviceImageView.image = UIImage(named: "lighton")
                deviceStateLabel.text = "\(device.value) %"
            }
        }
    }

    @IBAction func deviceStateChanged(_ sender: TactileSlider) {
        device.value = Int(sender.value)
        DeviceManager.instance.updateDeviceState(device: device) { (response) in
            self.updateDeviceIconAndState()
        }
    }

    class func instantiate() -> DeviceControlViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DeviceControlViewController")
    }



}
