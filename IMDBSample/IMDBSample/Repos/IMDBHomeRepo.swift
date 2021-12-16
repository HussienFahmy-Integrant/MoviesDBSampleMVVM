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
    private let mapClosure: (IMDBResponseResult) -> (IMDBRecord) = {
        IMDBRecord(id: $0.id,
                   originalTitle: $0.originalTitle ?? "",
                   overview: $0.overview ?? "",
                   posterPath: $0.posterImageW500,
                   releaseDate: $0.releaseDate ?? "",
                   title: $0.title ?? "")
    }

    @Published var domainObject: IMDBDomain?
    var subscriptions: [AnyCancellable] = []
    
    enum IMDBParams: String {
        case query
    }
    
    func loadMoviesList() {
        let trending = networkLayer.getExec(endPoint: .trendingMoviesDay, params: nil).map { $0.results }
        let nowPlaying = networkLayer.getExec(endPoint: .nowPlaying, params: nil).map { $0.results }
        let top = networkLayer.getExec(endPoint: .topRated, params: nil).map { $0.results }
       
       
        trending.zip(nowPlaying, top).sink(receiveCompletion: {print($0)}) {[weak self] (trending, nowPlaying, top) in
            guard let self = self else { return }
           
            let trendingRecords = trending?.compactMap {
                self.mapClosure($0)
            }
            
            let nowPlayingRecords = nowPlaying?.compactMap {
                self.mapClosure($0)
            }
            
            let topRecords = top?.compactMap {
                self.mapClosure($0)
            }
            self.domainObject = IMDBDomain(top: topRecords, trending: trendingRecords, nowPlaying: nowPlayingRecords)
            
        }.store(in: &subscriptions)

    }
    
    func search(query: String) {
        if !query.isEmpty {
            networkLayer.getExec(endPoint: .search, params: [IMDBParams.query.rawValue: query]).map { $0.results }
                .sink(receiveCompletion: {print($0)}) {[weak self] searchResults in
                    guard let self = self else { return }
                    let resultsMapped = searchResults?.compactMap {
                        self.mapClosure($0)
                    }
                    self.domainObject = IMDBDomain(top: self.domainObject?.top,
                                                   trending: self.domainObject?.trending,
                                                   nowPlaying: self.domainObject?.nowPlaying,
                                                   searchResults: resultsMapped)
                }.store(in: &subscriptions)
        }
    }
}
