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
    var networkHandler: IMDBNetworkProtocol { set get }
    func loadMoviesList() async throws -> IMDBHomeRecordsTuple
    func search(query: String) async throws -> [IMDBRecord]
}

final class IMDBHomeRepo: IMDBHomeRepoProtocol {
    
    public var networkHandler: IMDBNetworkProtocol = IMDBNetwork()
    
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

    func loadMoviesList() async throws -> IMDBHomeRecordsTuple {
        do {
            let trending = try await networkHandler.getExec(endPoint: .trendingMoviesDay, params: nil).results
            let nowPlaying = try await networkHandler.getExec(endPoint: .nowPlaying, params: nil).results
            let top = try await networkHandler.getExec(endPoint: .topRated, params: nil).results
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
        }
    }
    
    func search(query: String) async throws -> [IMDBRecord] {
        do {
            let results = try await networkHandler.getExec(endPoint: .search,
                                                           params: [IMDBParams.query.rawValue: query]).results
            return results?.compactMap {
                self.mapClosure($0)
            } ?? []
        }
    }

}
