//
//  DogBreedDetailViewController.swift
//  DogBreeds
//
//  Created by Rammel on 2022-03-07.
//

import UIKit

class DogBreedDetailViewController: UIViewController {
    
    var dogBreed: DogBreed!
    @IBOutlet weak var dogBreedImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func newDogImage(_ sender: UIButton) {
        fetchImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    func fetchImage() {
        //Initialize animations
        spinner.isHidden = false
        dogBreedImage.isHidden = true
        spinner.startAnimating()
        // fetch image using breed name
        fetchDogImage(dogBreed: dogBreed.name) { response in
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    self.dogBreedImage.image = data
                    self.dogBreed.image = data
                    self.dogBreedImage.isHidden = false
                    self.spinner.isHidden = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
