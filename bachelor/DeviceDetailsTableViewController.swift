//
//  DeviceSettingsTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 02.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class DeviceDetailsTableViewController: UITableViewController {

    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var deviceRoomLabel: UILabel!
    
    var room: Room!
    var device: Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }

    func refreshDetails() {
        deviceNameTextField.text = device.name
        deviceRoomLabel.text = room.name
    }
    
    @IBAction func deviceNameChangedTextfield(_ sender: UITextField) {
        let text = sender.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 1 {
            device.name = text
            DeviceManager.instance.updateNameForDevice(device: device) { (deviceResponse) in
                if deviceResponse.status == .ok {
                    self.device.name = deviceResponse.data!.name
                } else {
                    print("error")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshDetails()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RoomPickerTableViewController {
            destination.currentDevice = device
        }
    }
    

}
