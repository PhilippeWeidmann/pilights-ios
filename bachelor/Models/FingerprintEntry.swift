//
//  FingerprintEntry.swift
//  bachelor
//
//  Created by Philippe Weidmann on 13.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class FingerprintEntry: NSObject, Codable {

    let room: Room?
    var beaconValues: [Beacon]

    init(room: Room, beaconValues: [Beacon]) {
        self.room = room
        self.beaconValues = beaconValues
    }

    init(beaconValues: [Beacon]) {
        self.room = nil
        self.beaconValues = beaconValues
    }

}
