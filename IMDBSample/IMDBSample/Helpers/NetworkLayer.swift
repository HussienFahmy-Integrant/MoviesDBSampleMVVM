//
//  NetworkLayer.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine

class NetworkLayer {
    func executeRequest<DataModel>(
        endPoint: IMDBConstants.IMDBEndPoints,
        params: [String: Any]?,
        postRequest: Bool = false
    )
    -> AnyPublisher<DataModel, Error>
    where DataModel : Codable {
        let url = IMDBConstants.baseURL +
            endPoint.rawValue +
            "?api_key=" + IMDBConstants.apiKey
        let urlObject = URL(string: url)!
        var request = URLRequest(url: urlObject)
        request.httpMethod = postRequest ?  "POST" : "GET"
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: DataModel.self, decoder: JSONDecoder().self)
            .eraseToAnyPublisher()
    }
    
}
