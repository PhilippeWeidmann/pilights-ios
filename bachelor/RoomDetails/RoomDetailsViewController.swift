//
//  RoomDetailsViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class RoomDetailsViewController: UICollectionViewController {

    var room: Room!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = room.name

        self.collectionView.register(UINib(nibName: "DeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "deviceCell")
        self.collectionView.register(UINib(nibName: "RoomDetailsSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RoomDetailsSectionHeaderView")
        (self.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: 40)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return room.devices.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
        let device = room.devices[indexPath.row]
        cell.initWithDevice(device)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RoomDetailsSectionHeaderView", for: indexPath) as! RoomDetailsSectionHeaderView
        headerView.delegate = self
        return headerView
    }

    func headerViewDidPressLocationButton() {

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let device = room.devices[indexPath.row]
        if device.type == .dimmableLight {
            device.value = device.value == 0 ? 100 : 0
        }
        DeviceManager.instance.updateDeviceState(device: device) { (response) in
            self.collectionView.reloadData()
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
