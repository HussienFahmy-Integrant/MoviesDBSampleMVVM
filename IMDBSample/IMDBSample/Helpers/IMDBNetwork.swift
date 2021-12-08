//
//  IMDBNetwork.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 07/12/2021.
//

import Foundation
import Combine
protocol IMDBNetworkProcotol {
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String: Any]?) -> AnyPublisher<IMDBResponseRootClass, Error>
}

class IMDBNetwork: IMDBNetworkProcotol {

    private let networkLayer =  NetworkLayer()   
    
    func getExec(endPoint: IMDBConstants.IMDBEndPoints, params: [String: Any]?) -> AnyPublisher<IMDBResponseRootClass, Error> {
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
        let urlObject = URL(string: url)!
        let request = URLRequest(url: urlObject)
        return networkLayer.exec(request: request)

    }

}
