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
        composeSearchMoviePublisher()
        didAppear()
    }
    
    func didAppear() {
        isLoading.toggle()
        Task {
            do {
                let resultTuple = try await repo.loadMoviesList()
                await MainActor.run {
                    self.isLoading.toggle()
                    self.trending = resultTuple.trending ?? []
                    self.nowPlaying = resultTuple.nowPlaying ?? []
                    self.top = resultTuple.top ?? []
                }
            } catch {
                await MainActor.run {
                    self.isLoading.toggle()
                    print("Error happened while loading movies list: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func composeSearchMoviePublisher() {
        $searchKeyword.debounce(for: .milliseconds(800), scheduler: RunLoop.main).sink {[weak self] keyword in
            guard let self = self else { return }
            if !keyword.isEmpty {
                self.isLoading.toggle()
                Task {
                    do {
                        let results = try await self.repo.search(query: keyword)
                        await MainActor.run {
                            self.searchResults = results
                            self.isLoading.toggle()
                        }
                    }
                }
            }
        }.store(in: &subscriptions)
    }
}
