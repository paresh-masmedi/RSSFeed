//
//  NetworkManager.swift
//  RSS Feed
//
//  Created by Paresh Navadiya on 01/12/23.
//

import Foundation
import Combine


enum Endpoint: String {
    case backchannel = "backchannel"
    case economist = "the-economist"
    case matter = "matter"
}


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://medium.com/feed/"
    
    
    func getJSONData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
    
    func getXMLData<T: Decodable>(endpoint: Endpoint, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let self = self, let url = URL(string: self.baseURL.appending(endpoint.rawValue)) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            print("URL is \(url.absoluteString)")
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                // Parse XML data
                do {
                    let parser = XMLParser(data: data)
                    let delegate = CustomXMLParserDelegate()

                    parser.delegate = delegate
                    parser.parse()

                    // Access parsed data
                    let arrItems = delegate.items
//                    print(arrItems)
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: arrItems)
                    let models = try! JSONDecoder().decode([T].self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        promise(.success(models))
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(NetworkError.parsingFailed))
                    }
                }

            }.resume()
            
//            URLSession.shared.dataTaskPublisher(for: url)
//                .tryMap { (data, response) -> Data in
//                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
//                        throw NetworkError.responseError
//                    }
//
////                    let str = String(decoding: data, as: UTF8.self)
////                    print("Response: \(str)")
//
//                    let feeds = try XMLDecoder().decode(RSS.self, from: data)
//                    print("feeds: \(feeds)")
//
//                    return data
//                }
//                .decode(type: [T].self, decoder: XMLDecoder())
//                .receive(on: RunLoop.main)
//                .sink(receiveCompletion: { (completion) in
//                    if case let .failure(error) = completion {
//                        switch error {
//                        case let decodingError as DecodingError:
//                            promise(.failure(decodingError))
//                        case let apiError as NetworkError:
//                            promise(.failure(apiError))
//                        default:
//                            promise(.failure(NetworkError.unknown))
//                        }
//                    }
//                }, receiveValue: { promise(.success($0)) })
//                .store(in: &self.cancellables)
            
            
        }
        
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
    case parsingFailed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        case .parsingFailed:
            return NSLocalizedString("Parsing failed", comment: "Parsing failed")
        }
    }
}
