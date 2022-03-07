//
//  APIHelper.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import Foundation

enum FetchResult {
    case success(Data)
    case failure(Error)
}

struct APIHelper {
    private static let baseURL = "https://dog.ceo/api/breeds/list/all"
    
    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    static func fetch(url: String = baseURL, callback: @escaping (FetchResult) -> Void){
        guard
            let url = URL(string: url)
        else{return}
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, response, error in
            
            if let data = data {
                callback(.success(data))
            } else if let error = error{
                callback(.failure(error))
            }
            
        }
        task.resume()
    }
}
