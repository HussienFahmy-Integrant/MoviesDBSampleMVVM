//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
protocol HomeRepoContract {
    var networkLayer: IMDBNetworkProcotol { get }
    func trending() -> AnyPublisher<IMDBResponseRootClass, Error>
    func nowPlaying() -> AnyPublisher<IMDBResponseRootClass, Error>
    func top() -> AnyPublisher<IMDBResponseRootClass, Error>
    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error>
}

class IMDBHomeRepo: HomeRepoContract {
    let networkLayer: IMDBNetworkProcotol = IMDBNetwork()
    
   
    enum IMDBParams: String {
        case query
    }
        
    func trending() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.getExec(endPoint: .trendingMoviesDay, params: nil)
    }

    func nowPlaying() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.getExec(endPoint: .nowPlaying, params: nil)
    }

    func top() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.getExec(endPoint: .topRated, params: nil)
    }

    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error> {
        if !query.isEmpty {
            return networkLayer.getExec(endPoint: .search, params: [IMDBParams.query.rawValue: query])
        }
        return Empty().eraseToAnyPublisher()
    }
}
