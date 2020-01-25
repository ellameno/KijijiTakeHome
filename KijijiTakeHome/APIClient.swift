//
//  APIClient.swift
//  KijijiTakeHome
//
//  Created by Flannery Jefferson on 2020-01-25.
//  Copyright © 2020 Flannery Jefferson. All rights reserved.
//

import Foundation

typealias URLQueryParameters = [String: String]
public typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case post = "POST", get = "GET", put = "PUT", delete = "DELETE"
}

enum Result<T> {
    case success(T), failure(NetworkError)
}

enum NetworkError: Error {
    case requestFailed // Fall-back error - shouldn't occur.
    case invalidURL
    case parameterEncodingFailed
    case noData
    case decodingFailed
    case noResponse
    case fourOhFour
    
    var userMessage: String {
        switch self {
        case .noResponse:
            return "No response! Check your network connection."
        default:
            return "Woops! Something went wrong."
        }
    }
}
    

protocol Endpoint {
    var baseURL: URL? { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queryParams: URLQueryParameters { get }
}

enum APIRouter: Endpoint {
    case getCategories, getAdsForCategory(Category)

    var baseURL: URL? {
        return URL(string: "https://ios-interview.surge.sh")
    }
    
    var path: String {
        switch self {
        case .getCategories:
            return "categories"
        case .getAdsForCategory(let category):
            return "categories/\(category.id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var queryParams: URLQueryParameters {
        return URLQueryParameters()
    }
    
}

class APIClient {
    private let sessionConfig = URLSessionConfiguration.default
    private lazy var session = URLSession(configuration: sessionConfig)
    
    private var headers: HTTPHeaders {
        let headers = HTTPHeaders()
        // ... add any additional headers required
        return headers
    }
    
    func request<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T>) -> Void) {
        
        let dispatchCompletion = { (result: Result<T>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        do {
            let request = try self.buildRequest(for: endpoint)
            let task = session.dataTask(with: request, completionHandler: { data, urlResponse, error in
                guard let response = urlResponse else {
                    dispatchCompletion(.failure(.noResponse))
                    return
                }
                // @TODO: check for valid response code
                // @TODO: check for error
                
                guard let data = data else {
                    dispatchCompletion(.failure(.noData))
                    return
                }
                guard let decoded = try? self.decoder.decode(T.self, from: data) else {
                    dispatchCompletion(.failure(.decodingFailed))
                    return
                }
                dispatchCompletion(.success(decoded))
            })
            task.resume()
        } catch let error as NetworkError {
            dispatchCompletion(.failure(error))
        } catch {
            dispatchCompletion(.failure(NetworkError.requestFailed))
        }
    }
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let url = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        try encodeQueryParams(endpoint.queryParams, urlRequest: &request)
        try addHeaders(headers: self.headers, to: &request)
        return request
    }
    
    private func addHeaders(headers: HTTPHeaders, to request: inout URLRequest) throws {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func encodeQueryParams(_ parameters: URLQueryParameters, urlRequest: inout URLRequest) throws {
        guard let url = urlRequest.url else { throw NetworkError.invalidURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: value)
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }

}
