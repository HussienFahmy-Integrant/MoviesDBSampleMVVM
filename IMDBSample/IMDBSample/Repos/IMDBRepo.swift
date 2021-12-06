//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
class IMDBRepo {
   
    enum IMDBParams: String {
        case query
    }
    
    private let networkLayer = NetworkLayer()
    func trending() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.executeRequest(endPoint: .trendingMoviesDay, params: nil)
    }

    func nowPlaying() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.executeRequest(endPoint: .nowPlaying, params: nil)
    }

    func top() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.executeRequest(endPoint: .topRated, params: nil)
    }

    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error> {
        if !query.isEmpty {
            return networkLayer.executeRequest(endPoint: .search, params: [IMDBParams.query.rawValue: query])
        }
        return Empty().eraseToAnyPublisher()
    }
    
}
