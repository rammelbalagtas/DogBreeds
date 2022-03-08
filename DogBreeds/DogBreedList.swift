//
//  DogBreedList.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import Foundation
import UIKit

enum DogBreedResult {
    case success([DogBreed])
    case failure(Error)
}

enum DogImageResult{
    case success(UIImage)
    case failure(Error)
}

enum RandomDogImageResult{
    case success(DogImage)
    case failure(Error)
}

class DogBreedList: Codable {
    var message: [String:[String]]
}

class DogBreed {
    var name: String
    var subBreed: [String]
    var image: UIImage?
    init(name: String, subBreed: [String]) {
        self.name = name
        self.subBreed = subBreed
    }
}

struct DogImage: Codable {
    var message: String
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

func fetchDogImageURL(url: String, callback: @escaping (RandomDogImageResult) -> Void){
    APIHelper.fetch(url: url) { fetchResult in
        switch fetchResult {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let dogBreedImage = try decoder.decode(DogImage.self, from: data)
                callback(.success(dogBreedImage))
            } catch let e {
                print("could not parse json data \(e)")
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
    }
}

func fetchDogImage(dogBreed: String, callback: @escaping (DogImageResult) -> Void){
    let url = "https://dog.ceo/api/breed/\(dogBreed)/images/random"
    fetchDogImageURL(url: url) { response in
        switch response {
        case .success(let data):
            APIHelper.fetch(url: data.message) { fetchResult in
                switch fetchResult {
                case .success(let data):
                    guard
                        let image = UIImage(data: data)
                    else{return}
                    callback(.success(image))
                case .failure(let error):
                    print("there was an error fetchin information \(error)")
                }
            }
        case .failure(let error):
            print("there was an error fetchin information \(error)")
        }
        
    }
}
