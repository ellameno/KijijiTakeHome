//
//  ImageCacheTests.swift
//  KijijiTakeHomeTests
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import XCTest
@testable import KijijiTakeHome

class ImageCacheTests: BaseTestCase {
    
    var cache: ImageCache!
    var testImage: UIImage!
    
    override func setUp() {
        super.setUp()
        self.cache = ImageCache(config: ImageCache.Config(countLimit: 3, memoryLimit: 90000000))
        self.testImage = imageWithSize(size: CGSize(width: 300, height: 300))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRetreivingSavedImage() {
        let url = URL(string: "https://google.com")!
        cache.insertImage(testImage, for: url)
        
        let retrievedImage = cache.image(for: url)
        XCTAssertNotEqual(testImage, UIImage())
        XCTAssertEqual(testImage, retrievedImage)
    }
    
    func testRemovingSavedImage() {
        let url = URL(string: "https://google.com")!
        cache.insertImage(testImage, for: url)
        cache.removeImage(for: url)
        let retrievedImage = cache.image(for: url)
        XCTAssertNil(retrievedImage)
    }
    func testOverwritingExistingImage() {
        let firstImage = testImage
        let secondImage = UIImage()

        let url = URL(string: "https://google.com")!
        cache.insertImage(firstImage, for: url)
        cache.insertImage(secondImage, for: url)
        let retrievedImage = cache.image(for: url)
        XCTAssertNotEqual(firstImage, retrievedImage)
        XCTAssertEqual(secondImage, retrievedImage)
    }
    
    func testCacheDoesntSaveBeyondCapacity() {
        let url = URL(string: "https://google.com")!
        self.cache = ImageCache(config: ImageCache.Config(countLimit: 3, memoryLimit: 100))
        XCTAssertGreaterThan(testImage.diskSize, 100) // Prove image is greater then the cache's memory limit
        self.cache.insertImage(testImage, for: url)
        let retrievedImage = self.cache.image(for: url)
        XCTAssertNil(retrievedImage) // Cache should NOT save an image larger than the cache's limit
    }
    
    // MARK: Helper methods
    func imageWithSize(size: CGSize, filledWithColor color: UIColor = UIColor.clear, scale: CGFloat = 0.0, opaque: Bool = false) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
