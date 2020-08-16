//
//  NewsWidgetCollectionViewCell.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import UIKit

protocol NewsWidgetCollectionViewCellDelegate {
    func didTapOnNews(newsItem: Int)
}

class NewsWidgetCollectionViewCell: WidgetCollectionViewCell {

    @IBOutlet weak var firstNewsStackView: UIStackView!
    @IBOutlet weak var firstNewsImage: UIImageView!
    @IBOutlet weak var firstNewsTitle: UILabel!

    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var secondNewsImage: UIImageView!
    @IBOutlet weak var secondNewsTitle: UILabel!

    @IBOutlet weak var thirdStackView: UIStackView!
    @IBOutlet weak var thirdNewsImage: UIImageView!
    @IBOutlet weak var thirdNewsTitle: UILabel!

    var delegate: NewsWidgetCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstNewsImage.layer.cornerRadius = 5
        secondNewsImage.layer.cornerRadius = 5
        thirdNewsImage.layer.cornerRadius = 5

        firstNewsTitle.text = ""
        secondNewsTitle.text = ""
        thirdNewsTitle.text = ""

        firstNewsStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnNews(_:))))
        secondStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnNews(_:))))
        thirdStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnNews(_:))))
    }

    @objc func didTapOnNews(_ sender: UITapGestureRecognizer) {
        delegate?.didTapOnNews(newsItem: sender.view?.tag ?? 0)
    }
}
