//
//  URLSessionDataTaskMock.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    var _currentRequest: URLRequest?
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override var currentRequest: URLRequest? {
        return _currentRequest
    }
    
    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
