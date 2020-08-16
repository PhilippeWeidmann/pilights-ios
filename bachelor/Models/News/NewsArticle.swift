//
//  NewsArticle.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class NewsArticle: Codable {
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String
}
