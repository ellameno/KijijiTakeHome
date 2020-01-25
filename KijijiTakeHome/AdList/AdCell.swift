//
//  AdCell.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit
import Combine

class AdCell: UICollectionViewCell {
    var cancellable = Set<AnyCancellable>()
    
    static let reuseIdentifier = "AdCell"
    private var advertisement: Advertisement?
    private var image: AnyPublisher<UIImage?, Never>?
    
    func configure(with advertisement: Advertisement, imageLoader: ImageLoader) {
        self.advertisement = advertisement
        self.titleLabel.text = advertisement.title
        self.image = imageLoader.loadImage(from: advertisement.imageUrl)
        log.debug(advertisement.imageUrl)
        self.image!.sink(receiveValue: { image in
            self.imageView.image = image
        }).store(in: &cancellable)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.fill(view: contentView)
        contentView.addSubview(imageView)
        imageView.fill(view: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cancellable = Set<AnyCancellable>() // dispose of previous subscriptions
        self.imageView.image = nil
    }
}
