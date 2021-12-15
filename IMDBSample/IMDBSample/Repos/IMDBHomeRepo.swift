//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine

class IMDBHomeRepo {
    public var networkLayer: IMDBNetworkProcotol = IMDBNetwork()
    @Published var domainObject: IMDBDomain?
    var subscriptions: [AnyCancellable] = []
    enum IMDBParams: String {
        case query
    }
    
    func loadMoviesList() {
      
        let mapClosure: (IMDBResponseResult) -> (IMDBRecord) = {
            IMDBRecord(id: $0.id,
                       originalTitle: $0.originalTitle ?? "",
                       overview: $0.overview ?? "",
                       posterPath: $0.posterImageW500,
                       releaseDate: $0.releaseDate ?? "",
                       title: $0.title ?? "")
        }
        
        let trending = networkLayer.getExec(endPoint: .trendingMoviesDay, params: nil).map { $0.results }
        let nowPlaying = networkLayer.getExec(endPoint: .nowPlaying, params: nil).map { $0.results }
        let top = networkLayer.getExec(endPoint: .topRated, params: nil).map { $0.results }
       
       
        trending.zip(nowPlaying, top).sink(receiveCompletion: {print($0)}) {[weak self] (trending, nowPlaying, top) in
            guard let self = self else { return }
           
            let trendingRecords = trending?.compactMap {
                mapClosure($0)
            }
            
            let nowPlayingRecords = nowPlaying?.compactMap {
                mapClosure($0)
            }
            
            let topRecords = top?.compactMap {
                mapClosure($0)
            }
            self.domainObject = IMDBDomain(top: topRecords, trending: trendingRecords, nowPlaying: nowPlayingRecords)
            
        }.store(in: &subscriptions)

    }
    
    func search(query: String) -> AnyPublisher<IMDBResponseRootClass, Error> {
        if !query.isEmpty {
            return networkLayer.getExec(endPoint: .search, params: [IMDBParams.query.rawValue: query])
        }
        return Empty().eraseToAnyPublisher()
    }
}
