//
//  ImageLoader.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class ImageLoader {
    
    private var session: URLSession
    
    init(customSession: URLSession? = nil) {
        self.session = customSession ?? URLSession(configuration: URLSessionConfiguration.default)
    }
    private let cache = ImageCache()

    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[url] = image
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
