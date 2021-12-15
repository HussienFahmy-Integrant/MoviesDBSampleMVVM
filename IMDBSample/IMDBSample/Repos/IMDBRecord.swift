//
//  IMDBDomain.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 15/12/2021.
//

import Foundation
import Combine
class IMDBDomain: ObservableObject {
    var top: [IMDBRecord]? = nil
    var trending: [IMDBRecord]? = nil
    var nowPlaying: [IMDBRecord]? = nil
    var searchResults: [IMDBRecord]? = nil
    init(top: [IMDBRecord]?, trending: [IMDBRecord]?, nowPlaying: [IMDBRecord]?, searchResults: [IMDBRecord]? = nil) {
        self.top = top
        self.trending = trending
        self.nowPlaying = nowPlaying
        self.searchResults = searchResults
    }
}

class IMDBRecord: ObservableObject, Hashable {
    var id : Int? = nil
    var originalTitle : String = ""
    var overview : String = ""
    var posterPath : String = ""
    var releaseDate : String = ""
    var title : String = ""
    
    init(id: Int? = 0, originalTitle: String, overview : String, posterPath : String, releaseDate : String, title: String) {
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
    }
    
    static func == (lhs: IMDBRecord, rhs: IMDBRecord) -> Bool {
        return (lhs.id ?? 0) == (rhs.id ?? 0)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id ?? 0)
    }
}
