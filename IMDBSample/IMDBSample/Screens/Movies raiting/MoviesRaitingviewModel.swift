//
//  MoviesRaitingviewModel.swift
//  IMDBSample
//
//  Created by Hussien Fahmy on 06/12/2021.
//

import Foundation
import Combine
class MoviesRaitingviewModel: ObservableObject {
 
    @Published public var trending: [IMDBResponseResult] = []
    @Published public var nowPlaying: [IMDBResponseResult] = []
    @Published public var upcoming: [IMDBResponseResult] = []
    @Published public var top: [IMDBResponseResult] = []
    @Published public var searchKeyword = ""
    @Published public var searchResults: [IMDBResponseResult] = []
    @Published public var isLoading = false
    
    let repo : RepoContract
    var subscriptions: [AnyCancellable] = []

    init(repo: RepoContract) {
        self.repo = repo
        
        isLoading.toggle()
        repo.trending().receive(on: DispatchQueue.main).sink {
            print($0)
        } receiveValue: {[weak self] result in
            guard let self = self else { return }
            self.trending = result.results ?? []
        }.store(in: &subscriptions)

        repo.nowPlaying().receive(on: DispatchQueue.main).sink {
            print($0)
        } receiveValue: {[weak self] result in
            guard let self = self else { return }
            self.nowPlaying = result.results ?? []
        }.store(in: &subscriptions)

        repo.top().receive(on: DispatchQueue.main).sink {
            print($0)
        } receiveValue: {[weak self] result in
            guard let self = self else { return }
            self.top = result.results ?? []
            self.isLoading.toggle()
        }.store(in: &subscriptions)
        
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

}
