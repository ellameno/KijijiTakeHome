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
    case notFound
    case serverError
    case badRequest
    
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
             guard let url = endpoint.baseURL?.appendingPathComponent(endpoint.path) else {
                   throw NetworkError.invalidURL
               }
               var request = URLRequest(url: url)
               request.httpMethod = endpoint.httpMethod.rawValue
                let task = session.dataTask(with: request, completionHandler: { data, urlResponse, error in
                guard let response = urlResponse else {
                    dispatchCompletion(.failure(.noResponse))
                    return
                }
                if let error = self.getError(response, error) {
                    dispatchCompletion(.failure(error))
                    return
                }
                
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

    private func getError(_ response: URLResponse?, _ error: Error?) -> NetworkError? {
        func getErrorFromResponse(_ httpResponse: HTTPURLResponse?) -> NetworkError? {
            guard let httpResponse = httpResponse else {
                log.error("No response")
                return NetworkError.noResponse
            }

            log.debug("Status code: \(httpResponse.statusCode).")
            if httpResponse.statusCode >= 500 {
                log.debug("ServerError.")
                return NetworkError.serverError
            }

            if httpResponse.statusCode == 404 {
                log.debug("NotFound")
                return NetworkError.notFound
            }

            if httpResponse.statusCode >= 400 {
                log.debug("BadRequestError.")
                return NetworkError.badRequest
            }
            return nil
        }

        let httpResponse = response as? HTTPURLResponse
        if error != nil {
            log.error("Response: \(httpResponse?.statusCode ?? 0). Got error \(error?.localizedDescription ?? "nil").")

            // If we got one, we don't want to hit the response nil case above and
            // return a RecordParseError, because a RequestError is more fittinghttpResponse
            if let httpResponse = httpResponse, let result = getErrorFromResponse(httpResponse) {
                log.error("This was a failure response. Filled specific error type.")
                return result
            }

            log.error("Filling generic network error.")
            return NetworkError.requestFailed
        }

        if let result = getErrorFromResponse(httpResponse) {
            return result
        }

        return nil
    }
}
