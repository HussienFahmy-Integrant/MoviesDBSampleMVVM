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
        let expectation = expectation(description: "load movies list")
        repo.loadMoviesList().sink(receiveCompletion: {print($0)}) { resultTuple in
            expectation.fulfill()
            XCTAssertEqual((resultTuple.trending ?? []).count, 20)
            XCTAssertEqual((resultTuple.nowPlaying ?? []).count, 20)
            XCTAssertEqual((resultTuple.top ?? []).count, 20)
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testRepoSearchMovie() {
        let expectation = expectation(description: "search movie")
        repo.search(query: "avatar").sink(receiveCompletion: {print($0)}) { result in
            expectation.fulfill()
            XCTAssertEqual(result.count, 20)
        }.store(in: &subscriptions)
        wait(for: [expectation], timeout: 0.1)
    }
}
