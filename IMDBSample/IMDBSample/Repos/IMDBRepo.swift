//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
protocol RepoContract {
    var networkLayer: IMDBNetworkProcotol { get }
    func trending() -> AnyPublisher<IMDBResponseRootClass, Error>
    func nowPlaying() -> AnyPublisher<IMDBResponseRootClass, Error>
    func top() -> AnyPublisher<IMDBResponseRootClass, Error>
    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error>
}

class IMDBRepo: RepoContract {
    let networkLayer: IMDBNetworkProcotol = IMDBNetwork()
    
   
    enum IMDBParams: String {
        case query
    }
        
    func trending() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.execute(endPoint: .trendingMoviesDay, params: nil)
    }

    func nowPlaying() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.execute(endPoint: .nowPlaying, params: nil)
    }

    func top() -> AnyPublisher<IMDBResponseRootClass, Error> {
        networkLayer.execute(endPoint: .topRated, params: nil)
    }

    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error> {
        if !query.isEmpty {
            return networkLayer.execute(endPoint: .search, params: [IMDBParams.query.rawValue: query])
        }
        return Empty().eraseToAnyPublisher()
    }
}
