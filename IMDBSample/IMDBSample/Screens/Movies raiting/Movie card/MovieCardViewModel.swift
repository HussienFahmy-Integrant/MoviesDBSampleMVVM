//
//  MovieCardViewModel.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
class MovieCardViewModel: ObservableObject {
    @Published private var model: IMDBResponseResult
    public var posterURL: URL {
        URL(string: model.posterImageW500)!
    }
    public var movieTitle: String {
        model.originalTitle ?? ""
    }
    
    init(model: IMDBResponseResult) {
        self.model = model
    }
}
