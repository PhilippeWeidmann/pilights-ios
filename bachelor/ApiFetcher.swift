//
//  ApiFetcher.swift
//  bachelor
//
//  Created by Philippe Weidmann on 16.08.20.
//  Copyright © 2020 Philippe Weidmann. All rights reserved.
//

import Foundation
import Alamofire

class ApiFetcher {

    static let instance = ApiFetcher()
    private let decoder = JSONDecoder()

    private init() {

    }

    public func getNews(completion: @escaping (NewsResponse?) -> Void) {
        AF.request(
            "https://newsapi.org/v2/top-headlines?apiKey=a6d45856caa544dba983abacadd199c0&sources=le-monde",
            method: .get
        ).responseDecodable(of: NewsResponse.self, decoder: decoder) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(newsResponse)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }

}
