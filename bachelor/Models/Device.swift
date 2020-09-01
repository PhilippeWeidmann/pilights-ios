//
//  Device.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class Device: Codable, Comparable {
    
    enum DeviceType: String, Codable {
        case dimmableLight
        case beacon
        case thermometer
        case light
        
        var rank: Int {
            get {
                let ranks = [
                    DeviceType.dimmableLight: 1,
                    DeviceType.light: 1,
                    DeviceType.beacon: 10,
                    DeviceType.thermometer: 2
                ]
                return ranks[self]!
            }
        }
    }

    var id: Int
    var name: String
    var type: DeviceType
    var roomId: Int
    var value: Int
    var rank: Int {
        get {
            return type.rank
        }
    }
    var hidden: Bool {
        get {
            return type == .beacon
        }
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.id < rhs.id
    }
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }

}
