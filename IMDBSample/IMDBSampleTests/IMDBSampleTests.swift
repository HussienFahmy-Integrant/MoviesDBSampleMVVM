//
//  IMDBSampleTests.swift
//  IMDBSampleTests
//
//  Created by Hussien Fahmy on 25/11/2021.
//

import XCTest
import Combine
@testable import IMDBSample
class IMDBSampleTests: XCTestCase {
    var subscriptions: Set<AnyCancellable> = []
    let repo = IMDBHomeRepo()
    var viewModel: MoviesRaitingviewModel?

    override func setUp() {
        super.setUp()
        repo.networkHandler = MockIMDBNetwork()
        viewModel = MoviesRaitingviewModel(repo: repo)
    }
    
    func testRepoLoadMovies() {
        repo.loadMoviesList()
        let expectation = expectation(description: "load movies list")
        repo.$domainObject.dropFirst().sink { domainObject in
            expectation.fulfill()
            XCTAssertNotNil(domainObject)
            XCTAssertEqual(domainObject?.nowPlaying?.count , 20)
            XCTAssertEqual(domainObject?.top?.count , 20)
            XCTAssertEqual(domainObject?.trending?.count , 20)
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testRepoSearchMovie() {
        repo.search(query: "avatar")
        let expectation = expectation(description: "search movie")
        repo.$domainObject.dropFirst().sink { domainObject in
            expectation.fulfill()
            XCTAssertNotNil(domainObject)
            XCTAssertEqual(domainObject?.searchResults?.count , 20)
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testMoviesRaitingViewModel() {
        viewModel?.onAppear()
        let expectation = expectation(description: "setup view model")
        viewModel?.$nowPlaying.dropFirst().sink { movies in
            expectation.fulfill()
            XCTAssertEqual(movies.count, 20)
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 3)
    }
}
