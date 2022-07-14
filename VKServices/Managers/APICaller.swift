//
//  APICaller.swift
//  VKServices
//
//  Created by Dinar Garaev on 13.07.2022.
//

import Foundation

/// Класс, который отвечает за ход в сеть
final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    enum HTTPMethod: String {
        case GET
    }
    
    // MARK: - Fetch Services
    
    public func fetchServices(completion: @escaping (Result<ServiceResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL),
            type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }

                    do {
                        let results = try JSONDecoder().decode(ServiceResponse.self, from: data)
                        completion(.success(results))
                    } catch let error as NSError {
                        print("try! " + error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
    }
    
    // MARK: - Create Request
    
    private func createRequest(
        with url: URL?,
        type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        guard let apiURL = url else {
            return
        }
        var request = URLRequest(url: apiURL)
        request.httpMethod = type.rawValue
        completion(request)
    }
}
