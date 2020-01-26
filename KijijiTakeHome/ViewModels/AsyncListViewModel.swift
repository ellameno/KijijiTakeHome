//
//  AsyncListViewModel.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

class AsyncListViewModel<T: Decodable> {
    private var apiClient: APIClient
    private var dataEndpoint: APIRouter
    private(set) var screenTitle: String?
    
    init(title: String?, dataEndpoint: APIRouter, apiClient: APIClient = APIClient()) {
        self.screenTitle = title
        self.dataEndpoint = dataEndpoint
        self.apiClient = apiClient
    }
    
    private(set) var data: [T] = [] {
        didSet {
           onSetData?(data)
        }
    }
    private(set) var isLoading: Bool = false {
        didSet {
            onSetLoading?(isLoading)
        }
    }
    private(set) var errorMessage: String? {
        didSet {
           onSetErrorMessage?(errorMessage)
        }
    }
    
    var onSetData: (([T]) -> Void)?
    var onSetLoading: ((Bool) -> Void)?
    var onSetErrorMessage: ((String?) -> Void)?

    func fetchData() {
        self.isLoading = true
        apiClient.request(endpoint: dataEndpoint, completion: { (result: Result<[T]>) in
            self.isLoading = false
            switch result {
            case .success(let categories):
                self.data = categories
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
    func getItem(for indexPath: IndexPath) -> T {
        return data[indexPath.row]
    }
}
