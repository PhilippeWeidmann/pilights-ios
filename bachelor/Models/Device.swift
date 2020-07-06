//
//  Device.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.04.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class Device: Codable {
    
    enum DeviceType: String, Codable {
        case dimmableLight
        case beacon
    }
    
    var id: Int
    var name: String
    var type: DeviceType
    var roomId: Int
    var value: Int
    
}
