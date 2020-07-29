//
//  MainTabViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.07.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController, FingerprintManagerDelegate {

    let fingerprintManager = FingerprintManager.instance
    var currentRoomViewController: RoomDetailsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentRoomViewController = (viewControllers?.first as? UINavigationController)?.viewControllers.first as? RoomDetailsViewController
        currentRoomViewController.room = Room(name: "")

        DeviceManager.instance.refreshRooms {
            self.currentRoomViewController.room = DeviceManager.instance.rooms.first
        }
        fingerprintManager.delegate = self
    }

    func roomDidChange(newRoom: Room) {
        currentRoomViewController.room = newRoom
    }
}
