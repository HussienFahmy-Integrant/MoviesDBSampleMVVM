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
    @Published public var searchResults: [IMDBResponseResult] = []
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
        repo.$domainObject.dropFirst().receive(on: DispatchQueue.main).sink
        {[weak self] object in
            guard let self = self else { return }
            self.isLoading.toggle()
            self.trending = object?.trending ?? []
            self.nowPlaying = object?.nowPlaying ?? []
            self.top = object?.top ?? []
        }.store(in: &subscriptions)
    }
    
    func composeSearchMoviePublisher() {
        $searchKeyword.receive(on: DispatchQueue.main).sink {[weak self] keyword in
            guard let self = self else { return }
            if !keyword.isEmpty {
                self.isLoading.toggle()
                self.repo.search(query: keyword).receive(on: DispatchQueue.main).sink {
                    print($0)
                } receiveValue: {[weak self] result in
                    guard let self = self else { return }
                    self.searchResults = result.results ?? []
                    self.isLoading.toggle()
                }.store(in: &self.subscriptions)
            } else {
                self.searchResults = []
            }
        }.store(in: &subscriptions)
    }
    
    func onAppear() {
        repo.loadMoviesList()
    }

}
