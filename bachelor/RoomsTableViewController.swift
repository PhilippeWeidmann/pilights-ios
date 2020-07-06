//
//  RoomsTableViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 22.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class RoomsTableViewController: UITableViewController, CLLocationManagerDelegate {

    @IBOutlet weak var predictButton: UIBarButtonItem!
    let defaultUUID = "2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1"
    var locationManager = CLLocationManager()
    var beacons = [CLBeacon]()
    let beaconProximity = ["unknown", "immediate", "near", "far"]
    let knownBeacons = [1, 2, 3]
    var rooms = [Room]()
    let motionActivityManager = CMMotionActivityManager()
    let fileManager = FileManager.default

    let deviceManager = DeviceManager.instance

    var lastEntry: FingerprintEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        /*motionActivityManager.startActivityUpdates(to: .main) { (activity) in
            print(activity)
        }*/

        let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: defaultUUID)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: defaultUUID)
        locationManager.delegate = self
        locationManager.startMonitoring(for: beaconRegion)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.refreshDevices()
    }

    func refreshDevices() {
        deviceManager.refreshRooms {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        self.refreshDevices()
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
        var fingerprintBeacons = [Beacon]()
        for knownBeaconMinor in knownBeacons {
            let beacon = beacons.first(where: { $0.minor.intValue == knownBeaconMinor })
            if(beacon != nil && beacon?.rssi != -1) {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: beacon!.rssi))
            } else {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: -100))
            }
        }

        //let prediction = FingerprintStore.instance.nearestNeighbourFrom(entry: FingerprintEntry(roomName: "", beaconValues: fingerprintBeacons))
        //self.title = prediction.roomName
    }


    @IBAction func newRoomTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Room name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.deviceManager.rooms.insert(Room(name: textField!.text!.trimmingCharacters(in: .whitespacesAndNewlines)))
            self.tableView.reloadData()
            /*self.tableView.beginUpdates()
            //self.tableView.insertRows(at: [IndexPath(row: self.rooms.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()*/
        }))

        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func predictButtonPressed(_ sender: UIBarButtonItem) {

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return deviceManager.rooms.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceManager.getRooms()[section].devices.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if deviceManager.getRooms()[section].name == "" {
            return "Unassigned"
        } else {
            return deviceManager.getRooms()[section].name
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        let device = deviceManager.getRooms()[indexPath.section].devices[indexPath.row]

        cell.textLabel!.text = device.name

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()

            let room = rooms.remove(at: indexPath.row)
            //FingerprintStore.instance.removeRoom(room)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BeaconFinderTableViewController {
            let roomName = rooms[tableView.indexPath(for: sender as! UITableViewCell)!.row].name
            //destination.roomName = roomName
        }
        if let destination = segue.destination as? DeviceDetailsTableViewController {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let room = deviceManager.getRooms()[indexPath.section]
            let device = room.devices[indexPath.row]
            destination.device = device
            destination.room = room
        }
    }


}
