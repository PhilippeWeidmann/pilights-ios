//
//  RoomDetailsViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import PanModal

class RoomDetailsViewController: UICollectionViewController, DeviceCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout {

    var isCurrentRoomViewController = false
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isCurrentRoomViewController ? room.displayDevices.count : room.devices.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
        let device = isCurrentRoomViewController ? room.displayDevices[indexPath.row] : room.devices[indexPath.row]
        cell.initWithDevice(device)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RoomDetailsSectionHeaderView", for: indexPath) as! RoomDetailsSectionHeaderView
        headerView.delegate = self
        headerView.roomDetailsSubtitleLabel.text = room.summary
        headerView.locationButton.isHidden = isCurrentRoomViewController
        return headerView
    }

    func headerViewDidPressLocationButton() {
        FingerprintManager.instance.takeSnaphotFingerprintFor(room: room)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 68) / 3
        return CGSize(width: width, height: width)
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
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            device.value = device.value == 0 ? 100 : 0
            DeviceManager.instance.updateDeviceState(device: device) { (response) in
                self.collectionView.reloadData()
            }
        }
    }

    class func instantiate() -> RoomDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomDetailsViewController") as! RoomDetailsViewController
    }
}
