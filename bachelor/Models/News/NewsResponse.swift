//
//  NewsResponse.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation

class NewsResponse: Codable {
    var status: String
    var totalResults: Int
    var articles: [NewsArticle]?
}
