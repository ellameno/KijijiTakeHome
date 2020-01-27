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
    let PADDING: CGFloat = 8
    static let reuseIdentifier = "AdCell"
    private var advertisement: Advertisement?
    private var image: AnyPublisher<UIImage?, Never>?
    
    func configure(with advertisement: Advertisement, imageLoader: ImageLoader) {
        self.image = imageLoader.loadImage(from: advertisement.imageUrl)
        self.loadingIndicator.startAnimating()
        self.image!.sink(receiveValue: { image in
            self.loadingIndicator.stopAnimating()
            self.imageView.image = image
        }).store(in: &cancellable)
        
        self.advertisement = advertisement
        self.titleLabel.text = advertisement.title
        self.priceLabel.text = advertisement.price
    }
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 150),
            loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 24),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.format(as: .body)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.format(as: .strong)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, priceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: PADDING, left: PADDING, bottom: PADDING, right: PADDING)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(stackView)
        stackView.fill(view: contentView)
        backgroundColor = UIColor.highlightBackground
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
