//
//  NetworkLayer.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
public protocol NetworkLayerProtocol {
    func exec<DataModel>(
        request: URLRequest
    )
    -> AnyPublisher<DataModel, Error>
    where DataModel : Codable
}

final class NetworkLayer: NetworkLayerProtocol {
    func exec<DataModel>(
        request: URLRequest
    )
    -> AnyPublisher<DataModel, Error>
    where DataModel : Codable {
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: DataModel.self, decoder: JSONDecoder().self)
            .eraseToAnyPublisher()
    }
    
}
