//
//  DogBreedList.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import Foundation

enum DogBreedResult {
    case success([DogBreed])
    case failure(Error)
}

class DogBreedList: Codable {
    var message: [String:[String]]
}

struct DogBreed: Codable {
    var name: String
    var subBreed: [String]
}

func fetchDogBreed(callback: @escaping (DogBreedResult) -> Void){
    APIHelper.fetch { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let dogBreedResult = try decoder.decode(DogBreedList.self, from: data)
                let dogBreedResultSorted = dogBreedResult.message.sorted {
                    return $0.key < $1.key
                }
                var dogBreedList = [DogBreed]()
                for (breed, subbreed) in dogBreedResultSorted {
                    dogBreedList.append(DogBreed(name: breed, subBreed: subbreed))
                }
                
                callback(.success(dogBreedList))
                
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }

    }
}
