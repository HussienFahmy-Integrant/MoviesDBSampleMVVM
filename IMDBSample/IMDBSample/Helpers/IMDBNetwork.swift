//
//  IMDBNetwork.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 07/12/2021.
//

import Foundation
import Combine
enum IMDBNetworkError: Error {
   case urlInvalid
}

public protocol IMDBNetworkProtocol {
    var networkLayer: NetworkLayerProtocol { get set }
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String : Any]?) async throws -> IMDBResponseRootClass
    }

final class IMDBNetwork: IMDBNetworkProtocol {
    var networkLayer: NetworkLayerProtocol = NetworkLayer()    
    
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String : Any]?) async throws -> IMDBResponseRootClass {
        var url = IMDBConstants.baseURL +
            endPoint.rawValue +
            "?api_key=" + IMDBConstants.apiKey
        if let parameters = params {
            url += "&"
            parameters.keys.forEach { key in
                url += key + "=" + "\(String(describing: parameters[key] ?? ""))&"
            }
            url.removeLast()
        }
        url = url.replacingOccurrences(of: " ", with: "+")
        if let urlObject = URL(string: url) {
            let request = URLRequest(url: urlObject)
            let response = try await networkLayer.exec(request, IMDBResponseRootClass.self)
            return response
        }
        throw IMDBNetworkError.urlInvalid
    }
    
}
