//
//  FingerprintManager.swift
//  bachelor
//
//  Created by Philippe Weidmann on 13.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation
import CoreLocation

class FingerPrintManager: NSObject, CLLocationManagerDelegate {

    let beaconUUID = "2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1"
    var locationManager = CLLocationManager()
    static let instance = FingerPrintManager()
    var lastFingerprint: FingerprintEntry?
    var beacons = [CLBeacon]()
    var knownBeaconMinors = [Int]()
    var fingerprintEntries = [FingerprintEntry]()

    private override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        loadFingerprintEntries()
        
        let constraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: beaconUUID)!)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: constraint, identifier: beaconUUID)
        locationManager.delegate = self
        locationManager.startMonitoring(for: beaconRegion)
    }

    func loadFingerprintEntries() {
        let fileManager = FileManager.default
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let fileData = fileManager.contents(atPath: dir.relativePath + "/fingerprintstore.json"),
            let entries = try? JSONDecoder().decode([FingerprintEntry].self, from: fileData) {
            fingerprintEntries = entries
        } else {
            fingerprintEntries = [FingerprintEntry]()
        }
    }

    func saveFingerprintEntries() {
        let jsonData = try! JSONEncoder().encode(fingerprintEntries)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent("fingerprintstore.json")

            do {
                try String(data: jsonData, encoding: .utf8)!.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                print("Failed to save entries")
            }
        }
    }

    func takeSnaphotFingerprintFor(room: Room) {
        var fingerprintBeacons = [Beacon]()
        for knownBeaconMinor in knownBeaconMinors {
            let beacon = beacons.first(where: { $0.minor.intValue == knownBeaconMinor })
            if(beacon != nil && beacon?.rssi != -1 && beacon?.rssi != 0) {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: beacon!.rssi))
            } else {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: -100))
            }
        }
        let entry = FingerprintEntry(room: room, beaconValues: fingerprintBeacons)
        fingerprintEntries.append(entry)
        saveFingerprintEntries()
    }
    
    func nearestNeighbourFrom(entry: FingerprintEntry) -> FingerprintEntry {
        var nearest = fingerprintEntries.first!
        var distance = distanceBetween(lhs: entry, rhs: nearest)
        
        for neighbour in fingerprintEntries {
            let tmpDistance = distanceBetween(lhs: entry, rhs: neighbour)
            if tmpDistance < distance {
                distance = tmpDistance
                nearest = neighbour
            }
        }
        
        return nearest
    }
    
    func distanceBetween(lhs: FingerprintEntry, rhs: FingerprintEntry) -> Double {
        var value: Double = 0
        for i in 0...lhs.beaconValues.count - 1 {
            value+=pow(Double(lhs.beaconValues[i].rssi - rhs.beaconValues[i].rssi), 2)
        }
        return sqrt(value)
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
        for knownBeaconMinor in knownBeaconMinors {
            let beacon = beacons.first(where: { $0.minor.intValue == knownBeaconMinor })
            if(beacon != nil && beacon?.rssi != -1 && beacon?.rssi != 0) {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: beacon!.rssi))
            } else {
                fingerprintBeacons.append(Beacon(major: 1, minor: knownBeaconMinor, rssi: -100))
            }
        }
    }

}
