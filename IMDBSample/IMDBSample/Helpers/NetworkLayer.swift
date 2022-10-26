//
//  NetworkLayer.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
import Combine
public protocol NetworkLayerProtocol {
    func exec<T>(_ request: URLRequest,_ responseModel: T.Type) async throws -> T where T: Codable
}

final class NetworkLayer: NetworkLayerProtocol {
    
    func exec<T>(_ request: URLRequest,_ responseModel: T.Type) async throws -> T where T: Codable {
        do {
            let sessionRequest = try await URLSession.shared.data(for: request)
            let jsonDecoder = JSONDecoder()
            let data = sessionRequest.0
            return try jsonDecoder.decode(responseModel, from: data)
        }
    }
}
