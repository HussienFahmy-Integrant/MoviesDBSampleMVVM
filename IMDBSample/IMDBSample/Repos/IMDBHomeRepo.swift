//
//  OnSaleRepo.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine

public typealias IMDBHomeRecordsTuple = (top: [IMDBRecord]?,trending: [IMDBRecord]?,nowPlaying: [IMDBRecord]?)

protocol IMDBHomeRepoProtocol {
    var networkHandler: IMDBNetworkProcotol { set get }
    func loadMoviesList() -> AnyPublisher<IMDBHomeRecordsTuple, Error>
    func search(query: String) -> AnyPublisher<[IMDBRecord], Error>
}

final class IMDBHomeRepo: IMDBHomeRepoProtocol {
    
    public var networkHandler: IMDBNetworkProcotol = IMDBNetwork()
    
    private let mapClosure: (IMDBResponseResult) -> (IMDBRecord) = {
        IMDBRecord(id: $0.id,
                   originalTitle: $0.originalTitle ?? "",
                   overview: $0.overview ?? "",
                   posterPath: $0.posterImageW500,
                   releaseDate: $0.releaseDate ?? "",
                   title: $0.title ?? "")
    }
    
    
    enum IMDBParams: String {
        case query
    }
    
    func loadMoviesList() -> AnyPublisher<IMDBHomeRecordsTuple, Error> {
        
        let trending = networkHandler.getExec(endPoint: .trendingMoviesDay, params: nil).map { $0.results }
        let nowPlaying = networkHandler.getExec(endPoint: .nowPlaying, params: nil).map { $0.results }
        let top = networkHandler.getExec(endPoint: .topRated, params: nil).map { $0.results }
        
        return trending.zip(nowPlaying, top).map { (trending, nowPlaying, top) in
            
            let trendingRecords = trending?.compactMap {
                self.mapClosure($0)
            }
            
            let nowPlayingRecords = nowPlaying?.compactMap {
                self.mapClosure($0)
            }
            
            let topRecords = top?.compactMap {
                self.mapClosure($0)
            }
            return (top: topRecords,trending: trendingRecords,nowPlaying: nowPlayingRecords)
        }.eraseToAnyPublisher()
    }
    
    func search(query: String) -> AnyPublisher<[IMDBRecord], Error> {
        return networkHandler.getExec(endPoint: .search,
                                      params: [IMDBParams.query.rawValue: query])
            .map {
                let results = $0.results ?? []
                return results.compactMap {
                    self.mapClosure($0)
                }
            }
            .eraseToAnyPublisher()
    }
}
