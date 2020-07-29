//
//  DevicesCollectionViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

class DevicesCollectionViewController: UICollectionViewController, RoomSectionDelegate {

    let deviceManager = DeviceManager.instance
    let fingerprintManager = FingerPrintManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "DeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "deviceCell")
        collectionView.register(UINib(nibName: "RoomSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "roomTitleView")
        (collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)
        deviceManager.refreshRooms {
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return deviceManager.rooms.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deviceManager.getRooms()[section].devices.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
        let device = deviceManager.getRooms()[indexPath.section].devices[indexPath.row]
        cell.initWithDevice(device)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "roomTitleView", for: indexPath) as! RoomSectionHeaderView
        headerView.room = deviceManager.getRooms()[indexPath.section]
        headerView.delegate = self
        return headerView
    }


    func didTapOnHeader(_ header: RoomSectionHeaderView) {
        if let room = header.room {
            performSegue(withIdentifier: "roomDetailsSegue", sender: room)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RoomDetailsViewController {
            destination.room = sender as? Room
        }
    }

    class func instantiate() -> DevicesCollectionViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DevicesCollectionViewController") as! DevicesCollectionViewController
    }
}
