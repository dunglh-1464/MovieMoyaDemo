//
//  NetworkManager.swift
//  MovieApi+Moya
//
//  Created by Malcolm Kumwenda on 2018/01/17.
//  Copyright © 2018 mdevsa. All rights reserved.
//

import Foundation
import Moya

protocol Networkable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
    func getNewMovies(page: Int, completion: @escaping (([Movie])->()))
}

struct NetworkManager: Networkable {
    
    static let MovieAPIKey = "7a312711d0d45c9da658b9206f3851dd"
    let provider = MoyaProvider<MovieApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    func getNewMovies(page: Int, completion: @escaping ([Movie])->()){
        provider.request(.newMovies(page: page)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(MovieResults.self, from: response.data)
                    completion(results.movies)
                } catch let err {
                    print(err)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

