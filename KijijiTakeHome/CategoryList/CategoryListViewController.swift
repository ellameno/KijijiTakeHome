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
    private var viewModel = CategoryListViewModel()
    
    lazy var refreshControl = UIRefreshControl()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryItemCell.self, forCellWithReuseIdentifier: CategoryItemCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.screenTitle
        view.addSubview(collectionView)
        collectionView.fill(view: view)
        viewModel.onSetErrorMessage = { message in
            // @TODO
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).size.width
        return CGSize(width: availableWidth, height: CELL_HEIGHT)
    }
}
extension CategoryListViewController: CategoryItemCellDelegate {
    func didSelectCategory(_ category: Category) {
        let vc = AdListViewController(category: category)
        navigationController?.pushViewController(vc, animated: true)
    }  
}
