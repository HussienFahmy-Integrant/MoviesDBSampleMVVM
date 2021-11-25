//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
class IMDBRepo {
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
    
    func upcoming() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.executeRequest(endPoint: .upcoming, params: nil)
    }

}
