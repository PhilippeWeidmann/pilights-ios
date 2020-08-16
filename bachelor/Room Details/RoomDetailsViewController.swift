//
//  RoomDetailsViewController.swift
//  bachelor
//
//  Created by Philippe Weidmann on 10.06.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit
import PanModal
import Kingfisher

class RoomDetailsViewController: UICollectionViewController, DeviceCollectionViewCellDelegate, UICollectionViewDelegateFlowLayout, NewsWidgetCollectionViewCellDelegate {

    var isCurrentRoomViewController = false
    var room: Room! {
        didSet {
            title = room.name
            collectionView.reloadData()
        }
    }

    enum WidgetType {
        case news
        case recipes
    }

    var widgetType: WidgetType?
    var news: [NewsArticle]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = room.name

        collectionView.register(UINib(nibName: "DeviceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "deviceCell")
        collectionView.register(UINib(nibName: "NewsWidgetCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "widgetCell")
        collectionView.register(UINib(nibName: "RoomDetailsSectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RoomDetailsSectionHeaderView")
        collectionView.register(UINib(nibName: "TitleCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TitleCollectionReusableView")
        (collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)

        if room.name == "Salon" {
            widgetType = .news
        } else if room.name == "Cuisine" {
            widgetType = .recipes
        }
        
        if widgetType == .news {
            ApiFetcher.instance.getNews { (newsResponse) in
                if let news = newsResponse?.articles {
                    self.news = news
                    self.collectionView.reloadSections([0])
                }
            }
        }

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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if widgetType != nil {
                return 1
            } else {
                return 0
            }
        } else {
            return isCurrentRoomViewController ? room.displayDevices.count : room.devices.count
        }
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deviceCell", for: indexPath) as! DeviceCollectionViewCell
            let device = isCurrentRoomViewController ? room.displayDevices[indexPath.row] : room.devices[indexPath.row]
            cell.initWithDevice(device)
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "widgetCell", for: indexPath) as! NewsWidgetCollectionViewCell
            cell.delegate = self
            if widgetType == .news && news != nil {
                if news!.count > 0 {
                    cell.firstNewsImage.kf.setImage(with: URL(string: news![0].urlToImage))
                    cell.firstNewsTitle.text = news![0].title
                }
                if news!.count > 1 {
                    cell.secondNewsImage.kf.setImage(with: URL(string: news![1].urlToImage))
                    cell.secondNewsTitle.text = news![1].title
                }
                if news!.count > 2 {
                    cell.thirdNewsImage.kf.setImage(with: URL(string: news![2].urlToImage))
                    cell.thirdNewsTitle.text = news![2].title
                }
            } else if widgetType == .recipes {
                cell.firstNewsImage.image = Recipe.recipes[0].previewImage
                cell.firstNewsTitle.text = Recipe.recipes[0].title

                cell.secondNewsImage.image = Recipe.recipes[1].previewImage
                cell.secondNewsTitle.text = Recipe.recipes[1].title

                cell.thirdNewsImage.image = Recipe.recipes[2].previewImage
                cell.thirdNewsTitle.text = Recipe.recipes[2].title
            }
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RoomDetailsSectionHeaderView", for: indexPath) as! RoomDetailsSectionHeaderView
            headerView.delegate = self
            headerView.roomDetailsSubtitleLabel.text = room.summary
            headerView.locationButton.isHidden = isCurrentRoomViewController
            return headerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TitleCollectionReusableView", for: indexPath) as! TitleCollectionReusableView
            headerView.titleLabel.text = "Appareils"
            return headerView
        }
    }

    func headerViewDidPressLocationButton() {
        FingerprintManager.instance.takeSnaphotFingerprintFor(room: room)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let height = collectionView.frame.height * 0.3
            return CGSize(width: collectionView.frame.width - 48, height: height)
        } else {
            let width = (collectionView.frame.width - 68) / 3
            return CGSize(width: width, height: width)
        }
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

    func didTapOnNews(newsItem: Int) {
        if let url = URL(string: news![newsItem].url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    class func instantiate() -> RoomDetailsViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RoomDetailsViewController") as! RoomDetailsViewController
    }
}
