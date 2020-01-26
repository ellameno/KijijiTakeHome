//
//  ViewController.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {
    private var CELL_HEIGHT: CGFloat = 80
    private var viewModel = AsyncListViewModel<AdCategory>(title: Strings.categoryListScreenTitle,
                                                           dataEndpoint: APIRouter.getCategories)
    
    lazy var refreshControl = UIRefreshControl()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = CategoryFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryItemCell.self, forCellWithReuseIdentifier: CategoryItemCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.delaysContentTouches = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.screenTitle
        view.addSubview(collectionView)
        collectionView.fill(view: view)
        
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
extension CategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.reuseIdentifier, for: indexPath) as? CategoryItemCell else {
            fatalError("CategoryItemCell not registered with collection view")
        }
        let category = viewModel.getItem(for: indexPath)
        cell.configure(with: category)
        cell.delegate = self
        return cell
    }
}
extension CategoryListViewController: CategoryItemCellDelegate {
    func didSelectCategory(_ category: AdCategory) {
        let vc = AdListViewController(category: category)
        navigationController?.pushViewController(vc, animated: true)
    }  
}
