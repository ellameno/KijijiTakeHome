//
//  CategoryListTests.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import XCTest
@testable import KijijiTakeHome

class AsyncListViewModelTests: XCTestCase {
    var urlSessionMock: URLSessionMock!
    var apiClient: APIClient!
    var viewModel: AsyncListViewModel<AdCategory>!
    
    override func setUp() {
        super.setUp()
        self.urlSessionMock = URLSessionMock()
        self.apiClient = APIClient(customSession: urlSessionMock)
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "categories", withExtension: "json") else {
            XCTFail("Missing file: categories.json")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("couldnt get data")
        }
        urlSessionMock.setMockResponse(data: data, statusCode: 200, error: nil)
        
        self.viewModel = AsyncListViewModel<AdCategory>(title: Strings.categoryListScreenTitle,
                                                      dataEndpoint: .getCategories,
                                                      apiClient: apiClient)
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelInitialState() {
        XCTAssertEqual(viewModel.data.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testIsLoadingAfterFetchBegins() {
        let expectation = self.expectation(description: "fetchData should call onSetLoading callback")
        
        viewModel.onSetLoading = { loading in
            XCTAssertTrue(loading)
            expectation.fulfill()
            self.viewModel.onSetLoading = nil // prevent this being called a second time when loading set to false
        }
        viewModel.fetchData()
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error)
            return
        })
    }
    
    func testNotLoadingAfterFetchEnds() {
        let expectation = self.expectation(description: "fetchData should call onSetLoading callback twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onSetLoading = { loading in
            expectation.fulfill()
        }
        viewModel.fetchData()
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error)
            return
        })
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testDataCountAfterFetch() {
        let expectation = self.expectation(description: "fetchData should call onSetData callback")
        viewModel.onSetData = { data in
            XCTAssertEqual(data.count, self.viewModel.data.count)
            XCTAssertEqual(data.count, self.viewModel.getNumberOfRows(in: 0))
            expectation.fulfill()
        }
        viewModel.fetchData()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testErrorMessageAfterUnsuccessfulFetch() {
        urlSessionMock.setMockResponse(data: nil, error: NetworkError.badRequest)
        let expectation = self.expectation(description: "fetchData should call onSetErrorMessage callback")
        viewModel.onSetErrorMessage = { errorMessage in
            XCTAssertEqual(errorMessage, NetworkError.badRequest.userMessage)
            expectation.fulfill()
        }
        viewModel.fetchData()
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testNotLoadingAfterUnsuccessfulFetch() {
        urlSessionMock.setMockResponse(data: nil, error: NetworkError.badRequest)

        let expectation = self.expectation(description: "onSetLoading should be called twice")
        expectation.expectedFulfillmentCount = 2

        viewModel.onSetLoading = { loading in
            expectation.fulfill()
        }
        viewModel.fetchData()
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error)
            return
        })
        XCTAssertFalse(viewModel.isLoading)
    }
}
