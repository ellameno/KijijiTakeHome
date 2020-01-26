//
//  BaseTestCase.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import XCTest

class BaseTestCase: XCTestCase {
    let timeout: TimeInterval = 5
    
    static var testDirectoryURL: URL {
        return FileManager.temporaryDirectoryURL.appendingPathComponent("com.flannerykj.KijijiTakeHomeTests")
    }
    var testDirectoryURL: URL { return BaseTestCase.testDirectoryURL }
    
    override func setUp() {
        super.setUp()
        
        FileManager.removeAllItemsInsideDirectory(at: testDirectoryURL)
        FileManager.createDirectory(at: testDirectoryURL)
    }
    
    func url(forResource fileName: String, withExtension ext: String) -> URL {
        let bundle = Bundle(for: BaseTestCase.self)
        return bundle.url(forResource: fileName, withExtension: ext)!
    }
}
