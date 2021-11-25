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
    let repo = IMDBRepo()

    override func setUp() {
        super.setUp()
    }
    
    func testTrendingPopular() {
        let expection = XCTestExpectation(description: "Getting trending movies")
        repo.trending().sink { _ in
        } receiveValue: { movies in
            expection.fulfill()
            XCTAssertTrue(movies.results?.count ?? 0 > 0)
        }.store(in: &subscriptions)
        wait(for: [expection], timeout: 4)
    }
    
    func testNowPlaying() {
        let expection = XCTestExpectation(description: "now playing movies")
        repo.nowPlaying().sink { _ in
        } receiveValue: { movies in
            expection.fulfill()
            XCTAssertTrue(movies.results?.count ?? 0 > 0)
        }.store(in: &subscriptions)
        wait(for: [expection], timeout: 2)
    }
    
    func testTop() {
        let expection = XCTestExpectation(description: "top movies")
        repo.top().sink { _ in
        } receiveValue: { movies in
            expection.fulfill()
            XCTAssertTrue(movies.results?.count ?? 0 > 0)
        }.store(in: &subscriptions)
        wait(for: [expection], timeout: 2)
    }
    
    func testUpcoming() {
        let expection = XCTestExpectation(description: "upcoming movies")
        repo.upcoming().sink { _ in
        } receiveValue: { movies in
            expection.fulfill()
            XCTAssertTrue(movies.results?.count ?? 0 > 0)
        }.store(in: &subscriptions)
        wait(for: [expection], timeout: 2)
    }
}
