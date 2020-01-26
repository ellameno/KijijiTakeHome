//
//  URLSessionMock.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    var mockResponseData: Data?
    var mockResponseError: Error?
    var mockResponseStatusCode: Int = 200
    
    var shouldReturnEmptyResponse: Bool = false
    
    public func setMockResponse(data: Data?, statusCode: Int = 200, error: Error?, shouldReturnEmptyResponse: Bool = false) {
        self.mockResponseStatusCode = statusCode
        self.mockResponseData = data
        self.mockResponseError = error
        self.shouldReturnEmptyResponse = shouldReturnEmptyResponse
    }
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.mockResponseData
        let error = self.mockResponseError
        var response: HTTPURLResponse? = HTTPURLResponse(url: request.url!,
                                       statusCode: self.mockResponseStatusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        if shouldReturnEmptyResponse {
            response = nil
        }
        let task = URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
        task._currentRequest = request
        return task
    }
    
}
