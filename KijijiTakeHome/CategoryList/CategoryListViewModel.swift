//
//  CategoryListViewModel.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class CategoryListViewModel {
    private var apiClient = APIClient()
    
    private var data: [Category] = [] {
        didSet {
           onSetData?(data)
        }
    }
    private var isLoading: Bool = false {
        didSet {
            onSetLoading?(isLoading)
        }
    }
    private var errorMessage: String? {
        didSet {
           onSetErrorMessage?(errorMessage)
        }
    }
    
    var onSetData: (([Category]) -> Void)?
    var onSetLoading: ((Bool) -> Void)?
    var onSetErrorMessage: ((String?) -> Void)?

    init() {
        
    }
    func fetchData() {
        self.isLoading = true
        apiClient.request(endpoint: APIRouter.getCategories, completion: { (result: Result<[Category]>) in
            self.isLoading = false
            switch result {
            case .success(let categories):
                self.data = categories
                log.debug(categories)
            case .failure(let error):
                self.errorMessage = error.userMessage
                log.error(error)
            }
        })
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    func getNumberOfRows(in section: Int) -> Int {
        return data.count
    }
    func getItem(for indexPath: IndexPath) -> Category {
        return data[indexPath.row]
    }
}
