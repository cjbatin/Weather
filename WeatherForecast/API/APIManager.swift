//
//  APIManager.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import Foundation

final class APIRequester {
    static var shared: APIRequester {
        return APIRequester(session: URLSession.shared)
    }
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    let session: URLSession
    private var headers: [String: String] {
        return ["Content-type": "application/json"]
    }
    enum Method: String {
        case post = "POST"
        case get = "GET"
    }
    //Pass in url session, could pass in a mock so we don't call API's when unit testing
    private init(session: URLSession) {
        self.session = session
    }


    func createRequest(uri: String, method: Method = .get) -> URLRequest {
        let url = URL(string: uri)
        var request = URLRequest(url: url!)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func dataTask<T: Decodable>(urlRequest: URLRequest,
                                _ completion: @escaping (Swift.Result<T, FetchError>) -> Void)
        -> URLSessionDataTask {
        return session.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let response = urlResponse as? HTTPURLResponse else {
                completion(self.handleBadResponse())
                return
            }
            if let error = error {
                let fetchError = FetchError.error(error.localizedDescription)
                completion(Result.failure(fetchError))
            }
            switch response.statusCode {
            case 200..<300:
                completion(self.handleOkResponse(data: data))
            default:
                completion(self.handleFailedResponse())
            }
        }
    }

    private func handleOkResponse<T: Decodable>(data: Data?) -> Result<T, FetchError> {
        if let data = data {
            do {
                let decoded = try decoder.decode(T.self, from: data)
                return Result.success(decoded)
            } catch {
                let error = FetchError.error("Failed to decode data")
                return Result.failure(error)
            }
        } else {
            let error = FetchError.error("No Content")
            return Result.failure(error)
        }
    }

    private func handleBadResponse<T: Decodable>() -> Result<T, FetchError> {
        let error = FetchError.error("Something went wrong")
        return Result.failure(error)
    }

    private func handleFailedResponse<T: Decodable>() -> Result<T, FetchError> {
        let error = FetchError.error("Failed response")
        return Result.failure(error)
    }
}
