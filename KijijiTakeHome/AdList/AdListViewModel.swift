//
//  AdListViewModel.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class AdListViewModel {
    private var category: Category
    private var apiClient = APIClient()
    
    private var data: [Advertisement] = [] {
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
    
    var onSetData: (([Advertisement]) -> Void)?
    var onSetLoading: ((Bool) -> Void)?
    var onSetErrorMessage: ((String?) -> Void)?

    init(category: Category) {
        self.category = category
    }
    var screenTitle: String? {
        return category.name
    }
    
    func fetchData() {
        self.isLoading = true
        apiClient.request(endpoint: APIRouter.getAdsForCategory(self.category), completion: { (result: Result<[Advertisement]>) in
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
    func getItem(for indexPath: IndexPath) -> Advertisement {
        return data[indexPath.row]
    }
}
