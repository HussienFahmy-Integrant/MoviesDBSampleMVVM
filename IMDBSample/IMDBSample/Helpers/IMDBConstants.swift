//
//  IMDBConstants.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
public struct IMDBConstants {
    static let apiKey = "1330e694c7c90b77eee730df6ebb99fd"
    static let baseURL = "https://api.themoviedb.org/3/"
        
    public enum IMDBEndPoints: String {
        case trendingMoviesDay = "trending/movie/day"
        case nowPlaying = "movie/now_playing"
        case topRated = "movie/top_rated"
        case upcoming = "movie/upcoming"
        case search = "search/movie"
    }
    
}
