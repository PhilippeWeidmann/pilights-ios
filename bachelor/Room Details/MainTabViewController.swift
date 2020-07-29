//
//  MainTabViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 29.07.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {

    var currentRoomViewController: RoomDetailsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentRoomViewController = (viewControllers?.first as? UINavigationController)?.viewControllers.first as? RoomDetailsViewController
        currentRoomViewController.room = Room(name: "")

        DeviceManager.instance.refreshRooms {
            self.currentRoomViewController.room = DeviceManager.instance.rooms.first
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
