//
//  DevicesTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 18.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class DevicesTableViewController: UITableViewController, CBCentralManagerDelegate {

    var roomName: String!
    var centralManager: CBCentralManager!
    var scannedDevices = Set<DeviceFound>()
    var session: LearningSession!

    @IBOutlet weak var scanButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = roomName
        session = LearningSession(roomName: roomName)

        let fileManager = FileManager.default
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            print(dir.relativePath + "/\(roomName!).json")
            if let file = fileManager.contents(atPath: dir.relativePath + "/\(roomName!).json"),
                let fileContent = String(data: file, encoding: .utf8) {
                session = LearningSession(json: JSON(parseJSON: fileContent))
            }
        }

        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let result = scannedDevices.insert(DeviceFound(device: peripheral, rssi: RSSI.intValue))
        if(!result.inserted) {
            result.memberAfterInsert.rssi = RSSI.intValue
        }
        tableView.reloadData()
    }

    @IBAction func predictButtonPressed(_ sender: Any) {
        scannedDevices.removeAll()
        scanButton.isEnabled = false
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.scanButton.isEnabled = true
                self.centralManager.stopScan()
                var scannedValues = [UUID: Int]()
                for scannedDevice in self.scannedDevices {
                    scannedValues[scannedDevice.device.identifier] = -1 * scannedDevice.rssi
                }

                let guessedRoom = RoomGuesser.instance.guess(scannedValues: scannedValues)
                let alert = UIAlertController(title: "Room name", message: guessedRoom, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            })
    }

    @IBAction func scanButtonTapped(_ sender: Any) {
        scanButton.isEnabled = false
        centralManager.stopScan()
        centralManager.scanForPeripherals(withServices: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.scanButton.isEnabled = true
                self.centralManager.stopScan()
                for scannedDevice in self.scannedDevices {
                    if self.session.values[scannedDevice.device.identifier] != nil {
                        self.session.values[scannedDevice.device.identifier]!.append(scannedDevice.rssi)
                    } else {
                        self.session.values[scannedDevice.device.identifier] = [Int]()
                    }
                }
            })
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.write(string: session.toBadCSV(), toFile: self.roomName + ".csvl")
        self.write(string: session.toJSON().rawString([:])!, toFile: self.roomName + ".json")
    }

    func write(string: String, toFile: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(toFile)

            do {
                try string.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch { /* error handling here */ }
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedDevices.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let rssiLabel = cell.viewWithTag(2) as! UILabel
        let uuidLabel = cell.viewWithTag(3) as! UILabel

        let device = Array(scannedDevices.sorted(by: { $0.rssi > $1.rssi }))[indexPath.row]
        nameLabel.text = device.device.name
        uuidLabel.text = device.device.identifier.uuidString
        rssiLabel.text = "\(device.rssi)"
        return cell
    }

}
