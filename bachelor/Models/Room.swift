//
//  Room.swift
//  bachelor
//
//  Created by Philippe Weidmann on 22.03.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class Room: Codable, Equatable, Hashable, Comparable {

    var id: Int!
    var name: String!
    var devices: [Device]

    init(name: String) {
        self.id = 0
        self.name = name
        self.devices = [Device]()
    }

    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func < (lhs: Room, rhs: Room) -> Bool {
        return lhs.id < rhs.id
    }

}
