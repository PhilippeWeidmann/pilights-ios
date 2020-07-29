//
//  BeaconFinderTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 05.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconFinderTableViewController: UITableViewController, CLLocationManagerDelegate {

    let defaultUUID = "2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1"
    var locationManager = CLLocationManager()
    var beacons = [CLBeacon]()
    let beaconProximity = ["unknown", "immediate", "near", "far"]
    let knownBeacons = [1, 2, 3]
    var firstEntry: FingerprintEntry!
    var fingerPrintEntries = [FingerprintEntry]()
    var newFingerPrintEntries = [FingerprintEntry]()

    var roomName: String = "test"

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

        /*self.firstEntry = FingerprintEntry(roomName: roomName, beaconValues: [
            Beacon(major: 1, minor: 1, rssi: -100),
            Beacon(major: 1, minor: 2, rssi: -100),
            Beacon(major: 1, minor: 3, rssi: -100)])
        fingerPrintEntries = FingerprintStore.instance.getEntriesForRoom(Room(name: roomName))*/
        let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: defaultUUID)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: defaultUUID)
        self.locationManager.startMonitoring(for: beaconRegion)
    }

    @IBAction func snapButtonPressed(_ sender: UIBarButtonItem) {
        var fingerprintBeacons = [Beacon]()
        for knownBeaconMinor in knownBeacons {
            let beacon = beacons.first(where: { $0.minor.intValue == knownBeaconMinor })
            if(beacon != nil && beacon?.rssi != -1 && beacon?.rssi != 0) {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: beacon!.rssi))
            } else {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: -100))
            }
        }
        /*let entry = FingerprintEntry(roomName: roomName, beaconValues: fingerprintBeacons)
        fingerPrintEntries.append(entry)
        newFingerPrintEntries.append(entry)*/
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FingerprintStore.instance.addEntries(newFingerPrintEntries)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fingerPrintEntries.count + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell", for: indexPath)
        let entry = (indexPath.row > 0 ? fingerPrintEntries[indexPath.row - 1] : firstEntry)!

        let beaconButton1 = cell.viewWithTag(1) as! UIButton
        let beaconButton2 = cell.viewWithTag(2) as! UIButton
        let beaconButton3 = cell.viewWithTag(3) as! UIButton

        beaconButton1.setTitle("\(entry.beaconValues[0].rssi)", for: .normal)
        beaconButton2.setTitle("\(entry.beaconValues[1].rssi)", for: .normal)
        beaconButton3.setTitle("\(entry.beaconValues[2].rssi)", for: .normal)

        beaconButton1.backgroundColor = colorFor(rssi: entry.beaconValues[0].rssi)
        beaconButton2.backgroundColor = colorFor(rssi: entry.beaconValues[1].rssi)
        beaconButton3.backgroundColor = colorFor(rssi: entry.beaconValues[2].rssi)

        return cell
    }

    func colorFor(rssi: Int) -> UIColor {
        let absRssi = CGFloat(-1 * rssi)
        return UIColor(hue: (211 - absRssi) / 360, saturation: 1, brightness: 1, alpha: 1)
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let beaconRegion = region as? CLBeaconRegion
        if state == .inside {
            manager.startRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        } else {
            manager.stopRangingBeacons(satisfying: beaconRegion!.beaconIdentityConstraint)
        }
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        self.beacons.removeAll()
        self.beacons.append(contentsOf: beacons)

        var fingerprintBeacons = [Beacon]()
        for knownBeaconMinor in knownBeacons {
            let beacon = beacons.first(where: { $0.minor.intValue == knownBeaconMinor })
            if(beacon != nil && beacon?.rssi != -1 && beacon?.rssi != 0) {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: beacon!.rssi))
            } else {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: -100))
            }
        }
        //firstEntry = FingerprintEntry(roomName: roomName, beaconValues: fingerprintBeacons)

        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }


}
