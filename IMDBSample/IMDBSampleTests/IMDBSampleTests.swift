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
    
    func testRepoLoadMovies() async {
        do {
            let resultTuple = try await repo.loadMoviesList()
            XCTAssertEqual((resultTuple.trending ?? []).count, 20)
            XCTAssertEqual((resultTuple.nowPlaying ?? []).count, 20)
            XCTAssertEqual((resultTuple.top ?? []).count, 20)
        }
        catch {
            print("Unit testing Error: \(error)")
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRepoSearchMovie() async{
        do {
            let result = try await repo.search(query: "avatar")
            XCTAssertEqual(result.count, 20)
        }
        catch {
            print("Unit testing Error: \(error)")
            XCTFail(error.localizedDescription)
        }
    }
}
