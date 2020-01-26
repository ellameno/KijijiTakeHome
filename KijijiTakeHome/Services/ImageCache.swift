//
//  ImageCache.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

final class ImageCache {
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.countLimit = config.countLimit
        cache.totalCostLimit = config.memoryLimit
        return cache
    }()
    
    private let lock = NSLock()
    private let config: Config

    struct Config {
        let countLimit: Int
        let memoryLimit: Int

        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
    }

    init(config: Config = Config.defaultConfig) {
        self.config = config
    }
    
    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else {
            return removeImage(for: url)
        }
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject, cost: image.diskSize)
    }

    func removeImage(for url: URL) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
    }
    
    func image(for url: URL) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return imageCache.object(forKey: url as AnyObject) as? UIImage
    }
}
extension ImageCache {
    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        }
        set {
            return insertImage(newValue, for: key)
        }
    }
}
extension UIImage {
    var diskSize: Int {
        return self.jpegData(compressionQuality: 1.0)?.count ?? 0
    }
}
