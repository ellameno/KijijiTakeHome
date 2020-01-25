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
    private var viewModel: AdListViewModel
    
    init(category: Category) {
        self.viewModel = AdListViewModel(category: category)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var refreshControl = UIRefreshControl()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: AdCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension AdListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCell.reuseIdentifier, for: indexPath) as? AdCell else {
            fatalError("CategoryItemCell not registered with collection view")
        }
        let advertisement = viewModel.getItem(for: indexPath)
        cell.configure(with: advertisement)
        return cell
    }
}
