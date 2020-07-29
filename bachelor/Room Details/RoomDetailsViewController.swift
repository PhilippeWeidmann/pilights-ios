//
//  RoomDetailsViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import PanModal

class RoomDetailsViewController: UICollectionViewController, DeviceCollectionViewCellDelegate {

    var room: Room! {
        didSet {
            title = room.name
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = room.name

        collectionView.register(UINib(nibName: "DeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "deviceCell")
        collectionView.register(UINib(nibName: "RoomDetailsSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RoomDetailsSectionHeaderView")
        (collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
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
        cell.delegate = self
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

    }

    func didLongTouchWithDevice(_ device: Device) {
        let deviceController = DeviceControlViewController.instantiate()
        deviceController.device = device
        presentPanModal(deviceController)
    }

    func didTapWithDevice(_ device: Device) {
        if device.type == .dimmableLight {
            device.value = device.value == 0 ? 100 : 0
        }
        DeviceManager.instance.updateDeviceState(device: device) { (response) in
            self.collectionView.reloadData()
        }
    }

    class func instantiate() -> RoomDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomDetailsViewController") as! RoomDetailsViewController
    }
}
