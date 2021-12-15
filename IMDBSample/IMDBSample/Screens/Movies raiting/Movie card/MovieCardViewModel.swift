//
//  MovieCardViewModel.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import Foundation
class MovieCardViewModel: ObservableObject {
    @Published private var model: IMDBRecord
    public var posterURL: URL {
        URL(string: model.posterPath)!
    }
    public var movieTitle: String {
        model.originalTitle
    }
    
    init(model: IMDBRecord) {
        self.model = model
    }
}
