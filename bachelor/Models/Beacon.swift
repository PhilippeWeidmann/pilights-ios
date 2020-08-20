//
//  Beacon.swift
//  bachelor
//
//  Created by Philippe Weidmann on 13.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class Beacon: NSObject, Codable {

    let major: Int
    let minor: Int
    var rssi: Int

    init(major: Int, minor: Int, rssi: Int) {
        self.major = major
        self.minor = minor
        self.rssi = rssi
    }

    override var description: String {
        return "\(major) - \(minor) rssi: \(rssi)"
    }
}
