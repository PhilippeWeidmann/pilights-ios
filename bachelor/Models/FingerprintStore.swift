//
//  FingerprintSession.swift
//  bachelor
//
//  Created by Philippe Weidmann on 15.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

class FingerprintStore {

    static let instance = FingerprintStore()

    private let fileManager = FileManager.default
    var entries: [FingerprintEntry]

    private init() {
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
            let fileData = fileManager.contents(atPath: dir.relativePath + "/fingerprintstore.json"),
            let fileContent = String(data: fileData, encoding: .utf8) {

            let json = JSON(parseJSON: fileContent)
            entries = [FingerprintEntry]()
            for entryJson in json.arrayValue {
                //entries.append(FingerprintEntry(json: entryJson))
            }
        } else {
            entries = [FingerprintEntry]()
        }
    }
    
    func nearestNeighbourFrom(entry: FingerprintEntry) -> FingerprintEntry {
        var nearest = entries.first!
        var distance = distanceBetween(lhs: entry, rhs: nearest)
        
        for neighbour in entries {
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

    func addEntries(_ entries: [FingerprintEntry]) {
        self.entries.append(contentsOf: entries)
        save()
    }

    func save() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent("fingerprintstore.json")

            do {
                //try self.toJSON().rawString()?.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch { /* error handling here */ }
        }
    }

}
