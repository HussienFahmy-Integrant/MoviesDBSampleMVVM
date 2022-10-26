//
//  MockIMDBNetwork.swift
//  IMDBSampleTests
//
//  Created by Hussien Fahmy on 16/12/2021.
//

import Foundation
import Combine
@testable import IMDBSample

class MockIMDBNetwork: IMDBNetworkProtocol {
    var networkLayer: NetworkLayerProtocol = NetworkLayer()
    
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String : Any]?) async throws -> IMDBResponseRootClass {
        var url: URL?
        let bundle = Bundle(for: type(of: self))
        switch endPoint {
        case .nowPlaying:
            url = bundle.url(forResource: "nowPlaying", withExtension: "json")
        case .topRated:
            url = bundle.url(forResource: "topRated", withExtension: "json")
        case .trendingMoviesDay:
            url = bundle.url(forResource: "trending", withExtension: "json")
        case .search:
            url = bundle.url(forResource: "search", withExtension: "json")
        default:
            break
        }
        if let url = url {
            let request = URLRequest(url: url)
            return try await networkLayer.exec(request, IMDBResponseRootClass.self)
        } else {
            throw IMDBNetworkError.urlInvalid
        }
    }
}
