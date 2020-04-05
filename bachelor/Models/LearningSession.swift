//
//  LearningSession.swift
//  bachelor
//
//  Created by Philippe Weidmann on 22.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation
import SwiftyJSON

class LearningSession {

    let roomName: String
    var values = [UUID: [Int]]()

    init(roomName: String) {
        self.roomName = roomName
    }

    init(json: JSON) {
        roomName = json["sessionRoomName"].stringValue
        for jsonDevice in json["sessionDevices"].arrayValue {
            values[UUID(uuidString: jsonDevice["deviceUuid"].stringValue)!] = jsonDevice["deviceValues"].arrayObject as? [Int]
        }

    }

    func toJSON() -> JSON {
        var json = JSON()
        json["sessionRoomName"].string = roomName

        var jsonDevices = [JSON]()
        for device in values {
            var jsonDevice = JSON()
            jsonDevice["deviceUuid"].string = device.key.uuidString
            jsonDevice["deviceValues"].arrayObject = device.value
            jsonDevices.append(jsonDevice)
        }

        json["sessionDevices"].arrayObject = jsonDevices

        return json
    }

    func toBadCSV() -> String {
        var header = "room,"
        for deviceUUID in values.keys {
            header.append(contentsOf: deviceUUID.uuidString + ",")
        }
        header.removeLast()
        header.append("\n")
        var data = ""
        var emptyValues = true
        var i = 0
        repeat {
            emptyValues = true
            var row = "\(roomName),"
            for value in values.values {
                if value.count > i {
                    emptyValues = false
                    row += "\(value[i]),"
                } else {
                    row += "0,"
                }
            }
            if !emptyValues {
                row.removeLast()
                row.append("\n")
                data.append(contentsOf: row)
            }
            i += 1
        } while !emptyValues
        header.append(contentsOf: data)
        return header
    }

    func toCSV() -> String {
        var data = ""
        for device in values {
            data.append(contentsOf: "\(device.key.uuidString),")
            for value in device.value {
                data.append(contentsOf: "\(value),")
            }
            data.removeLast()
            data.append("\n")
        }
        return data
    }

}
