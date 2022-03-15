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
    
    override func setUp() {
        super.setUp()
        repo.networkHandler = MockIMDBNetwork()
    }
    
    func testRepoLoadMovies() {
        let resultTuple = try? awaitPublisher(repo.loadMoviesList())
        XCTAssertEqual((resultTuple?.trending ?? []).count, 20)
        XCTAssertEqual((resultTuple?.nowPlaying ?? []).count, 20)
        XCTAssertEqual((resultTuple?.top ?? []).count, 20)
    }
    
    func testRepoSearchMovie() {
        let result = try? awaitPublisher(repo.search(query: "avatar"), timeout: 0.1)
        XCTAssertEqual(result?.count ?? 0, 20)
    }
}
