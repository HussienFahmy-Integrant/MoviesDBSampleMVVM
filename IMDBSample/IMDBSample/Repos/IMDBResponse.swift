//
//  IMDBResponse.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation

import Foundation
public struct IMDBResponseRootClass : Codable {

        let page : Int?
        let results : [IMDBResponseResult]?
        let totalPages : Int?
        let totalResults : Int?

        enum CodingKeys: String, CodingKey {
                case page = "page"
                case results = "results"
                case totalPages = "total_pages"
                case totalResults = "total_results"
        }
    
    public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                page = try values.decodeIfPresent(Int.self, forKey: .page)
                results = try values.decodeIfPresent([IMDBResponseResult].self, forKey: .results)
                totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
                totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        }

}

class IMDBResponseResult : Codable, ObservableObject, Hashable {
    
    let adult : Bool?
    let backdropPath : String?
    let genreIds : [Int]?
    let id : Int?
    let mediaType : String?
    let originalLanguage : String?
    let originalTitle : String?
    let overview : String?
    let popularity : Float?
    let posterPath : String?
    let releaseDate : String?
    let title : String?
    let video : Bool?
    let voteAverage : Float?
    let voteCount : Int?
    var posterImageW500: String {
        "https://image.tmdb.org/t/p/w500" + (posterPath ?? "")
    }
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    
    static func == (lhs: IMDBResponseResult, rhs: IMDBResponseResult) -> Bool {
        return (lhs.id ?? 0) == (rhs.id ?? 0)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id ?? 0)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        mediaType = try values.decodeIfPresent(String.self, forKey: .mediaType)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        popularity = try values.decodeIfPresent(Float.self, forKey: .popularity)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        video = try values.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try values.decodeIfPresent(Float.self, forKey: .voteAverage)
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
    }
    
}
