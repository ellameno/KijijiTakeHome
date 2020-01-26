//
//  AdListViewController.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation
import UIKit

class AdListViewController: UIViewController {
    private var viewModel: AsyncListViewModel<Advertisement>
    private var CELL_HEIGHT: CGFloat = 200
    private var imageLoader = ImageLoader()
    private let SECTION_INSET: CGFloat = 12
    private let HORIZONTAL_ITEM_SPACING: CGFloat = 6
    private let VERTICAL_ITEM_SPACING: CGFloat = 12

    init(category: AdCategory) {
        self.viewModel = AsyncListViewModel<Advertisement>(title: category.name,
                                                           dataEndpoint: APIRouter.getAdsForCategory(category))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var refreshControl = UIRefreshControl()
    let flowLayout = UICollectionViewFlowLayout()

    lazy var collectionView: UICollectionView = {
        flowLayout.sectionInset = UIEdgeInsets(top: SECTION_INSET, left: SECTION_INSET, bottom: 0, right: SECTION_INSET)

        flowLayout.minimumInteritemSpacing = HORIZONTAL_ITEM_SPACING
        flowLayout.minimumLineSpacing = VERTICAL_ITEM_SPACING
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: AdCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.backgroundMain
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundMain
        navigationItem.title = viewModel.screenTitle
        view.addSubview(collectionView)
        collectionView.fillWithinSafeArea(view: view)
        viewModel.onSetErrorMessage = { message in
            self.showErrorAlert(message: message)
        }
        viewModel.onSetLoading = { isLoading in
            if isLoading {
                self.refreshControl.beginRefreshing()
            } else {
                self.refreshControl.endRefreshing()
            }
        }
        viewModel.onSetData = { _ in
            self.collectionView.reloadData()
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        viewModel.fetchData()
    }
    
    @objc func refreshData(_: UIRefreshControl) {
        viewModel.fetchData()
    }
}
extension AdListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCell.reuseIdentifier, for: indexPath) as? AdCell else {
            fatalError("CategoryItemCell not registered with collection view")
        }
        let advertisement = viewModel.getItem(for: indexPath)
        cell.configure(with: advertisement, imageLoader: imageLoader)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.inset(by: flowLayout.sectionInset).size.width
        return CGSize(width: availableWidth/2 - flowLayout.minimumInteritemSpacing, height: CELL_HEIGHT)
    }
}

