//
//  RoomPickerTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 02.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class RoomPickerTableViewController: UITableViewController {

    let deviceManager = DeviceManager.instance
    var currentDevice: Device!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return deviceManager.getRooms().count
        } else {
            return 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomNameCell", for: indexPath)
        if (indexPath.section == 0) {
            let room = deviceManager.getRooms()[indexPath.row]
            cell.accessoryType = currentDevice.roomId == room.id ? .checkmark : .none
            cell.textLabel?.text = room.name
        } else {
            cell.textLabel?.text = "New room"
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1) {
            self.addNewRoom()
        } else {
            let room = deviceManager.getRooms()[indexPath.row]
            currentDevice.roomId = room.id
            deviceManager.updateRoomFor(device: self.currentDevice) { (response) in
                if let previousViewController = self.navigationController?.viewControllers[((self.navigationController?.viewControllers.firstIndex(of: self)!)!) - 1] as? DeviceDetailsTableViewController {
                    previousViewController.room = room
                }

                self.tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func addNewRoom() {
        let alert = UIAlertController(title: "Room name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let newRoomName = textField!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if newRoomName != "" {
                self.deviceManager.createRoom(roomName: newRoomName) { (roomResponse) in
                    if roomResponse.status == .ok {
                        self.currentDevice.roomId = roomResponse.data!.id
                        self.deviceManager.rooms.insert(roomResponse.data!)
                        self.deviceManager.updateRoomFor(device: self.currentDevice) { (deviceResponse) in
                            if let previousViewController = self.navigationController?.viewControllers[((self.navigationController?.viewControllers.firstIndex(of: self)!)!) - 1] as? DeviceDetailsTableViewController {
                                previousViewController.room = roomResponse.data!
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

}
