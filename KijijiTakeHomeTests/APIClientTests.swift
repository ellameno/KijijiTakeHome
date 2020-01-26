//
//  APIClientTests.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import XCTest
@testable import KijijiTakeHome

class APIClientTests: XCTestCase {
    var urlSessionMock: URLSessionMock!
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        self.urlSessionMock = URLSessionMock()
        self.apiClient = APIClient(customSession: urlSessionMock)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSuccessfulResponse() {
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "categories", withExtension: "json") else {
            XCTFail("Missing file: categories.json")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("couldnt get data")
        }

        urlSessionMock.setMockResponse(data: data, statusCode: 200, error: nil)

        let expectation = self.expectation(description: "Request should succeed.")

        apiClient.request(endpoint: APIRouter.getCategories, completion: {(res: Result<[AdCategory]>) in
            switch res {
            case .success(let categories):
                XCTAssertEqual(categories.count, 2)
                expectation.fulfill()
            case .failure(let error):
                print(error)
                XCTFail("Request should be successful.")
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testInvalidJSONThrowsDecodingError() {
        
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "invalid_categories", withExtension: "json") else {
            XCTFail("Missing file: categories.json")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("couldnt get data")
        }

        urlSessionMock.setMockResponse(data: data, statusCode: 200, error: nil)

        let expectation = self.expectation(description: "Request should throw decoding error.")

        apiClient.request(endpoint: APIRouter.getCategories, completion: {(res: Result<[AdCategory]>) in
            switch res {
            case .success(_):
                XCTFail("Request should not be successful.")
            case .failure(let error):
                expectation.fulfill()
                XCTAssertEqual(error, .decodingFailed)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFourOhFourThrowsCorrectError() {
        urlSessionMock.setMockResponse(data: Data(), statusCode: 404, error: nil)

        let expectation = self.expectation(description: "Request should fail with NotFound error")

        apiClient.request(endpoint: APIRouter.getCategories, completion: {(res: Result<[AdCategory]>) in
            switch res {
            case .success(_):
                XCTFail("Request should not return success.")
            case .failure(let error):
                XCTAssertEqual(error, .notFound)
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testNoResponseThrowsCorrectError() {
        urlSessionMock.setMockResponse(data: nil, error: nil, shouldReturnEmptyResponse: true)

        let expectation = self.expectation(description: "Request should fail with NotFound error")

        apiClient.request(endpoint: APIRouter.getCategories, completion: {(res: Result<[AdCategory]>) in
            switch res {
            case .success(_):
                XCTFail("Request should not return success.")
            case .failure(let error):
                XCTAssertEqual(error, .noResponse)
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
