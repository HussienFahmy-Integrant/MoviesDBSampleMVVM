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
    
    let repo : IMDBHomeRepoProtocol
    var subscriptions: [AnyCancellable] = []
    
    init(repo: IMDBHomeRepoProtocol) {
        self.repo = repo
        composeMoviesListPublishers()
        composeSearchMoviePublisher()
    }
    
    func composeMoviesListPublishers() {
        isLoading.toggle()
        repo.loadMoviesList().sink {
            print($0)
        } receiveValue: { resultTuple in
            Task {
                await MainActor.run {
                    self.isLoading.toggle()
                    self.trending = resultTuple.trending ?? []
                    self.nowPlaying = resultTuple.nowPlaying ?? []
                    self.top = resultTuple.top ?? []
                }
            }
        }.store(in: &subscriptions)
    }
    
    func composeSearchMoviePublisher() {
        $searchKeyword.debounce(for: .milliseconds(800), scheduler: RunLoop.main).sink {[weak self] keyword in
            guard let self = self else { return }
            if !keyword.isEmpty {
                self.isLoading.toggle()
                self.repo.search(query: keyword).receive(on: DispatchQueue.main).sink(receiveCompletion: {print($0)}) { results in
                    self.searchResults = results
                    self.isLoading.toggle()
                }.store(in: &self.subscriptions)
            }
        }.store(in: &subscriptions)
    }
}
