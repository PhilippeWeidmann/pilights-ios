//
//  DeviceFound.swift
//  bachelor
//
//  Created by Philippe Weidmann on 22.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import CoreBluetooth

class DeviceFound: Hashable, Equatable, Comparable {

    let device: CBPeripheral
    var rssi: Int

    init(device: CBPeripheral, rssi: Int) {
        self.device = device
        self.rssi = rssi
    }

    static func < (lhs: DeviceFound, rhs: DeviceFound) -> Bool {
        return lhs.device.identifier.uuidString < rhs.device.identifier.uuidString
    }

    static func == (lhs: DeviceFound, rhs: DeviceFound) -> Bool {
        return lhs.device.identifier == rhs.device.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(device.identifier)
    }
}
