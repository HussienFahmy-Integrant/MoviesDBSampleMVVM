//
//  MockIMDBNetwork.swift
//  IMDBSampleTests
//
//  Created by Hussien Fahmy on 16/12/2021.
//

import Foundation
import Combine
@testable import IMDBSample

class MockIMDBNetwork: IMDBNetworkProcotol {
    var networkLayer: NetworkLayerProtocol = NetworkLayer()
    
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String : Any]?) -> AnyPublisher<IMDBResponseRootClass, Error> {
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
        
        let request = URLRequest(url: url!)
        return networkLayer.exec(request: request)
    }
    
    
}
