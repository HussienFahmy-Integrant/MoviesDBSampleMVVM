//
//  MoviesRaitingviewModel.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 06/12/2021.
//

import Foundation
import Combine
class MoviesRaitingviewModel: ObservableObject {
 
    @Published public var trending: [IMDBRecord] = []
    @Published public var nowPlaying: [IMDBRecord] = []
    @Published public var upcoming: [IMDBRecord] = []
    @Published public var top: [IMDBRecord] = []
    @Published public var searchKeyword = ""
    @Published public var searchResults: [IMDBRecord] = []
    @Published public var isLoading = false
    
    let repo : IMDBHomeRepo
    var subscriptions: [AnyCancellable] = []

    init(repo: IMDBHomeRepo) {
        self.repo = repo
        composeMoviesListPublishers(repo)
        composeSearchMoviePublisher()
    }
    
    func composeMoviesListPublishers(_ repo: IMDBHomeRepo) {
        isLoading.toggle()
        repo.$domainObject.receive(on: DispatchQueue.main).sink
        {[weak self] object in
            guard let self = self else { return }
            if let object = object {
                self.isLoading.toggle()
                self.trending = object.trending ?? []
                self.nowPlaying = object.nowPlaying ?? []
                self.top = object.top ?? []
                self.searchResults = object.searchResults ?? []
            }
        }.store(in: &subscriptions)
    }
    
    func composeSearchMoviePublisher() {
        $searchKeyword.receive(on: DispatchQueue.main).sink {[weak self] keyword in
            guard let self = self else { return }
            if !keyword.isEmpty {
                self.isLoading.toggle()
                self.repo.search(query: keyword)
            }
        }.store(in: &subscriptions)
    }
    
    func onAppear() {
        repo.loadMoviesList()
    }

}
